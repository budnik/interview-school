class SchedulesController < ApplicationController
  before_action :enforce_session_or_token, :fetch_available_sections, only: :show
  DOPPIO_TOKEN = ENV.fetch('DOPPIO_TOKEN')
  def show
    respond_to do |format|
      format.pdf { send_data(generated_pdf, filename: 'schedule.pdf', type: 'application/pdf')}
      format.html do
        sections = current_user.sections.group_by(&:day_of_week)

        m = [sections['mwf'], sections['everyday']].flatten.compact.sort_by(&:starts_at)
        t = [sections['tt'], sections['everyday']].flatten.compact.sort_by(&:starts_at)

        @student_sections_by_day = [m,t,m,t,m]
        @available_sections = fetch_available_sections
      end
    end
  end

  private

  def fetch_available_sections
    busy_at = current_user
      .sections
      .pluck(:day_of_week, :starts_at, :ends_at)
      .group_by(&:shift)
      .transform_values(&:flatten)

    conflicting_sections = Section.running_at(busy_at['everyday'])
                                  .or(Section.tt.running_at(busy_at['tt']))
                                  .or(Section.mwf.running_at(busy_at['mwf']))

    Section.where.not(id: conflicting_sections)
  end

  def generated_pdf
    url = URI("https://api.doppio.sh/v1/render/pdf/sync")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Authorization"] = "Bearer " + DOPPIO_TOKEN
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
      "page": {
        "pdf": {
          "printBackground": true
        },
        "goto": {
          "url": schedule_url(token: encryptor.encrypt_and_sign(current_user.id))
        }
      }
    })
    response = https.request(request)
    puts response.read_body
  end

  def enforce_session_or_token
    current_user || user_from_token || redirect_to(root_path)
  end

  def user_from_token
    return unless params[:token]

    @current_user ||= Student.find(encryptor.decrypt_and_verify(params[:token]))
  end

  def encryptor
    ActiveSupport::MessageEncryptor.new(Rails.application.secret_key_base[0..31])
  end
end
