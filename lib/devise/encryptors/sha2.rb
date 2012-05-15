require 'digest/sha2'
module Devise
  module Encryptors
    class Sha2 < Base
      def self.digest(password, stretches, salt, pepper)
        Digest::SHA2.hexdigest(password)
      end
    end
  end
end
