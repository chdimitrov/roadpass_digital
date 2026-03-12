class TripRatingSummaryJob < ApplicationJob
  queue_as :default

  def perform
    counts  = Trip.group(:rating).count
    total   = counts.values.sum
    average = total.zero? ? 0.0 : Trip.average(:rating).to_f.round(2)

    lines = [
      "===== Nightly Trip Rating Summary (#{Time.current.utc.strftime('%Y-%m-%d')}) =====",
      "Total trips : #{total}"
    ]

    (1..5).each do |star|
      count   = counts.fetch(star, 0)
      percent = total.zero? ? 0 : (count * 100.0 / total).round(1)
      lines << "  #{star} star#{'s' if star > 1} : #{count} trip#{'s' if count != 1} (#{percent}%)"
    end

    lines << "Average     : #{average}"
    lines << "=" * 55

    Rails.logger.info lines.join("\n")
  end
end
