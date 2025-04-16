namespace :stations do
  desc "Tạo 3 trụ thu gom mẫu để thử nghiệm"
  task seed_fake: :environment do
    Station.destroy_all

    stations = [
      { name: "Trụ Quận 1", location: "Nguyễn Huệ, Q1", password: "truaq1" },
      { name: "Trụ Gò Vấp", location: "Lê Đức Thọ, Gò Vấp", password: "trugv" },
      { name: "Trụ Tân Bình", location: "Hoàng Văn Thụ, Tân Bình", password: "trutb" }
    ]

    stations.each do |data|
      Station.create!(
        name: data[:name],
        location: data[:location],
        password: data[:password]
      )
    end

    puts "✅ Đã tạo 3 trụ thu gom mẫu"
  end
end
