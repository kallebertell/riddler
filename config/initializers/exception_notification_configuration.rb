Riddler::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[Riddler@#{Rails.env}] ",
  :sender_address => %{"notifier" <riddler.application@gmail.com>},
  :exception_recipients => %w{riddler.application@gmail.com}
