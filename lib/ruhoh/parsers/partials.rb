class Ruhoh
  module Parsers
    module Partials
    
      def self.generate
        partials = self.system_widget_partials.merge(self.user_widget_partials)
        partials.merge(self.global_partials).merge(self.theme_partials)
      end
      
      def self.theme_partials
        self.process(Ruhoh.paths.partials)
      end
      
      def self.global_partials
        self.process(Ruhoh.paths.global_partials)
      end

      def self.system_widget_partials
        self.process_widgets(File.join(Ruhoh::Root, 'widgets'))
      end
      
      def self.user_widget_partials
        self.process_widgets(Ruhoh.paths.widgets)
      end
      
      def self.process_widgets(path)
        return {} unless File.exist?(path)

        partials = {}
        FileUtils.cd(path) {
          Dir["*/partials/*"].each do |filename|
            name = 'widgets/' + filename.gsub('/partials/', '/')
            partials[name] = File.open(filename) { |f| f.read }
          end
        }
        partials      
      end
      
      def self.process(path)
        return {} unless File.exist?(path)
      
        partials = {}
        FileUtils.cd(path) {
          Dir.glob("**/*").each { |filename|
            next if FileTest.directory?(filename)
            next if ['.'].include? filename[0]
            File.open(filename) { |f| partials[filename] = f.read }
          }
        }
        partials
      end
    
    end #Partials
  end #Parsers
end #Ruhoh