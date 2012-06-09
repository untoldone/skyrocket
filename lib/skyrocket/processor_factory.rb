module Skyrocket
  class ProcessorFactory
   
    PROCESSORS = [ CoffeescriptProcessor, ErbProcessor, LessProcessor ]

    def process?(filename)
      PROCESSORS.each do |processor|
        return true if processor.new.process?(filename)
      end
      return false
    end

    def post_process_name(filename)
      if process?(filename)
        processor(filename).post_process_name(filename)
      else
        filename
      end
    end

    def processor(filename)
      PROCESSORS.each do |processor|
        return processor.new if processor.new.process?(filename)
      end
      raise NoValidProcessorError
    end
  end
end
