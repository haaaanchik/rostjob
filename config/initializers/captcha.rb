require 'digest/md5'
require 'securerandom'

class Captcha
  def self.get_text secret, random, alphabet='abcdefghijklmnopqrstuvwxyz', character_count = 6
    if character_count < 1 || character_count > 16
      raise "Character count of #{character_count} is outside the range of 1-16"
    end

    input = "#{secret}#{random}"

    if alphabet != 'abcdefghijklmnopqrstuvwxyz' || character_count != 6
      input << ":#{alphabet}:#{character_count}"
    end

    bytes = Digest::MD5.hexdigest(input).slice(0..(2*character_count - 1)).scan(/../)
    text = ''

    bytes.each do |byte|
      text << alphabet[byte.hex % alphabet.size].chr
    end

    text
  end

  def self.get_random
    random_string = SecureRandom.hex.first(16)
  end

  def self.password(random)
    key = '4agpzK97RcB3gelHaCWGujlA7mDlw2bGask4I3Jb'
    self.get_text(key, random)
  end

  def self.check(user_response, random)
    self.password(random) == user_response
  end
end 

