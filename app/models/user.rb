class User < ActiveRecord::Base
  attr_accessor :password
  before_save :downcase_name
  before_save :encrypt_password
  after_save :clear_password
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :password, confirmation: true, presence: true,
    length: { minimum: 6 }
  default_scope -> { order(name: :asc) }

  # überprüft Login Passwort
  def authenticate(login_password = "")
    encrypted_password  == BCrypt::Engine.hash_secret(login_password, salt)
  end

  private
    # macht alle Buchstaben des Namens zu kleinen und den Ersten Groß
    def downcase_name
      self.name = name.downcase.capitalize
    end

    # verschlüsselt das Passwort
    def encrypt_password
      if password.present?
        self.salt = BCrypt::Engine.generate_salt
        self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
      end
    end

    # löscht das unverschlüsselte Passwort
    def clear_password
      self.password = nil
    end
end
