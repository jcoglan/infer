module Infer
  class Pager

    PAGER_CMD = 'less'
    PAGER_ENV = { 'LESS' => 'FRSX', 'LV' => '-c' }

    def self.capture
      if $stdout.isatty
        new.tap { yield }.wait
      else
        yield
      end
    end

    attr_reader :input

    def initialize
      env = PAGER_ENV.merge(ENV)
      cmd = env['PAGER'] || PAGER_CMD

      reader, writer = IO.pipe
      options = { :in => reader, :out => $stdout, :err => $stderr }
      @pid = Process.spawn(env, cmd, options)

      reader.close
      $stdout = writer
    end

    def wait
      $stdout.close_write
      Process.waitpid(@pid)
    end

  end
end
