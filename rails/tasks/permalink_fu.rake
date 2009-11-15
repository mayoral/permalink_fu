namespace :permalinks do
  desc 'Regenerates permalinks for a given MODEL.'
  task :rebuild => :environment do
    model_name = ENV['MODEL']
    raise "Must specify MODEL" unless model_name

    model = model_name.constantize
    field = model.permalink_field

    model.update_all("#{field} = ''")

    model.find_each do |record|
      puts "#{model} #{record.id}"
      record.send("#{field}=", nil)
      record.send(:create_unique_permalink)
      value = record.send(field)
      puts "=> #{value}"
      model.update_all("#{field} = '#{value}'", "id = #{record.id}")
    end
  end
end