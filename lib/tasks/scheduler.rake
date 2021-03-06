desc 'Run Scrummer scheduled tasks'

namespace :redmine_scrummer do

  task :scheduler => :environment do
    # send daily notification for sprints started tryoday
    # this task run at early morning 1:00 AM
    versions = Version.all.select do |v| 
      start_date = v.try(:start_date_custom_value)

      start_date && start_date == Date.yesterday
    end

    versions.each do |sprint|
      Mailer.sprint_start(sprint).deliver
    end

    # send email when the version has one or three days to end
    # send email when the version ends !
    Version.where(["effective_date >= ?", Date.today]).each do |version|
      days = version.remaining_working_days.count

      if [1, 3].include?(days)
        Mailer.sprint_before_end(version, days).deliver
      end

      if days.zero?
        Mailer.sprint_end(version).deliver
      end

    end

  end
end
