module WordsHelper
  def plural?(str)
    str.pluralize == str && str.singularize != str
  end

  def singular?(str)
    str.pluralize != str && str.singularize == str
  end
end
