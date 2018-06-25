module EncodableModelIds
  #http://www.miguelsanmiguel.com/2011/04/03/hideous-obfuscated-ids
  MAXID = 2147483647  # (2**31 - 1)
  PRIME = 687270821#a very big prime number of your choice (like 9 digits big)
  PRIME_INVERSE = 19006509#another big integer number so that (PRIME * PRIME_INVERSE) & MAXID == 1
  RNDXOR = 748743845#some random big integer number, just not bigger than MAXID
  
  def encoded_id
    (((id * PRIME) & MAXID) ^ RNDXOR).to_s(16)
  end

  module ClassMethods
    def find_by_encoded_id encoded_id
      self.find_by_id(((encoded_id.to_i(16) ^ RNDXOR) * PRIME_INVERSE) & MAXID)
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
end
