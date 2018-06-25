namespace :product_categories do

  desc "Update product categories (december 2012)"
  task :update_december_2012 => :environment do

    ActiveRecord::Base.transaction do


      # Apparel Clothing Women
      puts "Apparel Clothing Women"
      acw = ProductCategory.roots.find_by_name("Apparel Clothing Women")

      acw1 = acw.children.find_by_name("Activewear")
      # update old categories
      acw1.children.find_by_name("Shoes and Sneakers").update_attributes!(:name => "Sneakers")
      # create new categories
      ProductCategory.create(:name => "Running Gear", :parent => acw1)
      ProductCategory.create(:name => "Workout Clothes", :parent => acw1)
      ProductCategory.create(:name => "Other", :parent => acw1)

      acw2 = acw.children.find_by_name("Outerwear")
      # create new categories
      ProductCategory.create(:name => "Gloves and Mittens", :parent => acw2)
      ProductCategory.create(:name => "Sweaters", :parent => acw2)
      ProductCategory.create(:name => "Rain Gear", :parent => acw2)
      ProductCategory.create(:name => "Long Underwear", :parent => acw2)
      ProductCategory.create(:name => "Hats Gloves and Scarfs", :parent => acw2)
      ProductCategory.create(:name => "Other", :parent => acw2)

      acw3 = acw.children.find_by_name("Sleepwear and Loungwear")
      # create new categories
      ProductCategory.create(:name => "Maternity", :parent => acw3)
      ProductCategory.create(:name => "Other", :parent => acw3)

      acw4 = acw.children.find_by_name("Swimwear")
      # create new categories
      ProductCategory.create(:name => "Wraps", :parent => acw4)
      ProductCategory.create(:name => "Wetsuits", :parent => acw4)
      ProductCategory.create(:name => "Sunglasses", :parent => acw4)
      ProductCategory.create(:name => "Plus Size", :parent => acw4)
      ProductCategory.create(:name => "Other", :parent => acw4)

      acw5 = acw.children.find_by_name("Formal Wear")
      # create new categories
      ProductCategory.create(:name => "Sleeveless Dresses", :parent => acw5)
      ProductCategory.create(:name => "Short Sleeve", :parent => acw5)
      ProductCategory.create(:name => "One Shoulder", :parent => acw5)
      ProductCategory.create(:name => "Other", :parent => acw5)


      # Apparel Clothing Men
      puts "Apparel Clothing Men"
      acm = ProductCategory.roots.find_by_name("Apparel Clothing Men")

      acm1 = acm.children.find_by_name("Activewear")
      # update old categories
      acm1.children.find_by_name("Shoes and Sneakers").update_attributes!(:name => "Sneakers")
      # create new categories
      ProductCategory.create(:name => "Shoes", :parent => acm1)
      ProductCategory.create(:name => "Running Gear", :parent => acm1)
      ProductCategory.create(:name => "Workout Clothes", :parent => acm1)
      ProductCategory.create(:name => "Hiking Gear", :parent => acm1)
      ProductCategory.create(:name => "Other", :parent => acm1)

      acm2 = acm.children.find_by_name("Outerwear")
      # create new categories
      ProductCategory.create(:name => "Gloves and Mittens", :parent => acm2)
      ProductCategory.create(:name => "Sweaters", :parent => acm2)
      ProductCategory.create(:name => "Rain Gear", :parent => acm2)
      ProductCategory.create(:name => "Long Underwear", :parent => acm2)
      ProductCategory.create(:name => "Hats Gloves and Scarfs", :parent => acm2)
      ProductCategory.create(:name => "Other", :parent => acm2)

      acm3 = acm.children.find_by_name("Sleepwear and Loungwear")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => acm3)

      acm4 = acm.children.find_by_name("Swimwear")
      # create new categories
      ProductCategory.create(:name => "Wetsuits", :parent => acm4)
      ProductCategory.create(:name => "Other", :parent => acm4)

      acm5 = acm.children.find_by_name("Formal Wear")
      # create new categories
      ProductCategory.create(:name => "Long Sleeve Shirts", :parent => acm5)
      ProductCategory.create(:name => "Short Sleeve Shirts", :parent => acm5)
      ProductCategory.create(:name => "Pocket Squares", :parent => acm5)
      ProductCategory.create(:name => "Socks", :parent => acm5)
      ProductCategory.create(:name => "Other", :parent => acm5)


      # Apparel Accessories Men and Women
      puts "Apparel Accessories Men and Women"
      aamw = ProductCategory.roots.find_by_name("Apparel Accessories Men and Women")

      aamw1 = aamw.children.find_by_name("Clothing Accessories Women")
      # create new categories
      ProductCategory.create(:name => "Sunglasses", :parent => aamw1)
      ProductCategory.create(:name => "Glasses", :parent => aamw1)
      ProductCategory.create(:name => "Scarfs", :parent => aamw1)

      aamw2 = aamw.children.find_by_name("Clothing Accessories Men")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => aamw2)


      # Art and Entertainment
      puts "Art and Entertainment"
      ae = ProductCategory.roots.find_by_name("Art and Entertainment")
      ae.update_attributes!(:name => "Art, Entertainment, Gifts and Books")

      ae1 = ae.children.find_by_name("Crafts and Hobbies")
      # create new categories
      ProductCategory.create(:name => "Models", :parent => ae1)
      ProductCategory.create(:name => "Baking", :parent => ae1)
      ProductCategory.create(:name => "Other", :parent => ae1)

      ae2 = ae.children.find_by_name("Musical Instruments")
      # update old categories
      ae2.children.find_by_name("Amplifier/Speakers").update_attributes!(:name => "Equipment")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => ae2)

      ae3 = ae.children.find_by_name("Party and Celebration")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => ae3)

      ae4 = ae.children.find_by_name("Books: Children")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => ae4)

      ae5 = ae.children.find_by_name("Books: Fiction")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => ae5)

      ae6 = ae.children.find_by_name("Books: Non-Fiction")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => ae6)

      ae7 = ae.children.find_by_name("Music")
      ae7.update_attributes!(:name => "Music & Movies")
      # create new categories
      ProductCategory.create(:name => "Movies", :parent => ae7)
      ProductCategory.create(:name => "Other", :parent => ae7)

      ae8 = ProductCategory.create(:name => "Food and Beverage Gifts", :parent => ae)
      # create new categories
      ProductCategory.create(:name => "Gift Baskets and Towers", :parent => ae8)
      ProductCategory.create(:name => "Chocolates & Sweets", :parent => ae8)
      ProductCategory.create(:name => "Gourmet Foods", :parent => ae8)
      ProductCategory.create(:name => "Flowers and Plants", :parent => ae8)
      ProductCategory.create(:name => "Holiday and Special Occasions", :parent => ae8)
      ProductCategory.create(:name => "Wine Baskets", :parent => ae8)
      ProductCategory.create(:name => "Coffee, Tea and Cocoa", :parent => ae8)
      ProductCategory.create(:name => "Other", :parent => ae8)


      # Baby and Toddler
      puts "Baby and Toddler"
      bt = ProductCategory.roots.find_by_name("Baby and Toddler")

      bt1 = bt.children.find_by_name("Baby Safety")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => bt1)

      bt2 = bt.children.find_by_name("Baby Furniture")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => bt2)

      bt4 = bt.children.find_by_name("Baby Supplies")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => bt4)

      bt5 = bt.children.find_by_name("Baby Toys")
      # create new categories
      ProductCategory.create(:name => "Rattles", :parent => bt5)
      ProductCategory.create(:name => "Teething Toys", :parent => bt5)
      ProductCategory.create(:name => "Other", :parent => bt5)


      # Electronics
      puts "Electronics"
      el = ProductCategory.roots.find_by_name("Electronics")

      el1 = el.children.find_by_name("TV's and Accessories")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => el1)

      el2 = el.children.find_by_name("Cameras and Accessories")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => el2)

      el3 = el.children.find_by_name("Mobile and Audio")
      # create new categories
      ProductCategory.create(:name => "Speakers", :parent => el3)
      ProductCategory.create(:name => "Ipods", :parent => el3)
      ProductCategory.create(:name => "Other", :parent => el3)

      el4 = el.children.find_by_name("Computers")
      # create new categories
      ProductCategory.create(:name => "All in One Computers", :parent => el4)
      ProductCategory.create(:name => "Accessories", :parent => el4)
      ProductCategory.create(:name => "Other", :parent => el4)

      el5 = el.children.find_by_name("GPS")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => el5)

      el6 = el.children.find_by_name("Print, Copy, Scan and Fax")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => el6)

      el7 = el.children.find_by_name("Gaming Consoles")
      # create new categories
      ProductCategory.create(:name => "Wii U Consoles", :parent => el7)
      ProductCategory.create(:name => "Other", :parent => el7)


      # Furniture
      puts "Furniture"
      fr = ProductCategory.roots.find_by_name("Furniture")

      fr1 = fr.children.find_by_name("Baby Furniture")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => fr1)

      fr2 = fr.children.find_by_name("Bedroom Furniture")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => fr2)

      fr3 = fr.children.find_by_name("Living Room Furniture")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => fr3)

      fr4 = fr.children.find_by_name("Outdoor Furniture")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => fr4)


      # Home and Garden
      puts "Home and Garden"
      hg = ProductCategory.roots.find_by_name("Home and Garden")

      hg1 = hg.children.find_by_name("Countertops")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => hg1)

      hg2 = hg.children.find_by_name("Flooring")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => hg2)

      hg3 = hg.children.find_by_name("Home Decor")
      # create new categories
      ProductCategory.create(:name => "Clocks", :parent => hg3)
      ProductCategory.create(:name => "Candles", :parent => hg3)
      ProductCategory.create(:name => "Ceiling fans", :parent => hg3)
      ProductCategory.create(:name => "Decorative Accessories", :parent => hg3)
      ProductCategory.create(:name => "Collectibles", :parent => hg3)
      ProductCategory.create(:name => "Other", :parent => hg3)

      hg4 = hg.children.find_by_name("Lawn and Garden")
      # create new categories
      ProductCategory.create(:name => "Generators", :parent => hg4)
      ProductCategory.create(:name => "Chippers and Shredders", :parent => hg4)
      ProductCategory.create(:name => "Wheelbarrows", :parent => hg4)
      ProductCategory.create(:name => "Fencing", :parent => hg4)
      ProductCategory.create(:name => "Patio Storage", :parent => hg4)
      ProductCategory.create(:name => "Shed and Outdoor Storage", :parent => hg4)
      ProductCategory.create(:name => "Other", :parent => hg4)

      hg5 = hg.children.find_by_name("Fireplace and Wood Stove")
      # create new categories
      ProductCategory.create(:name => "Gas Stoves", :parent => hg5)
      ProductCategory.create(:name => "Other", :parent => hg5)

      hg6 = hg.children.find_by_name("Appliances")
      # create new categories
      ProductCategory.create(:name => "Warming Ovens", :parent => hg6)
      ProductCategory.create(:name => "Freezers and Ice Makers", :parent => hg6)
      ProductCategory.create(:name => "Wine Cellars", :parent => hg6)
      ProductCategory.create(:name => "Other", :parent => hg6)

      hg7 = hg.children.find_by_name("Kitchen and Dining")
      # create new categories
      ProductCategory.create(:name => "Cutlery", :parent => hg7)
      ProductCategory.create(:name => "Flatware", :parent => hg7)
      ProductCategory.create(:name => "Serveware", :parent => hg7)
      ProductCategory.create(:name => "Cookware", :parent => hg7)
      ProductCategory.create(:name => "Bakeware", :parent => hg7)
      ProductCategory.create(:name => "Glasses and Barware", :parent => hg7)
      ProductCategory.create(:name => "Other", :parent => hg7)

      hg8 = hg.children.find_by_name("Luggage and Travel Bags")
      # create new categories
      ProductCategory.create(:name => "Kids Luggage & Bags", :parent => hg8)
      ProductCategory.create(:name => "Other", :parent => hg8)

      hg9 = hg.children.find_by_name("Pet Care")
      # create new categories
      ProductCategory.create(:name => "Health and Wellness", :parent => hg9)
      ProductCategory.create(:name => "Other", :parent => hg9)


      # Sporting Goods
      puts "Sporting Goods"
      sg = ProductCategory.roots.find_by_name("Sporting Goods")
      sg.update_attributes!(:name => "Sporting Goods & Equipment")

      sg1 = sg.children.find_by_name("Combat Sports")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => sg1)

      sg2 = sg.children.find_by_name("Yoga")
      # create new categories
      ProductCategory.create(:name => "Accessories", :parent => sg2)
      ProductCategory.create(:name => "Other", :parent => sg2)

      sg3 = sg.children.find_by_name("Exercise and Fitness")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => sg3)

      sg4 = sg.children.find_by_name("Indoor Games")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => sg4)

      sg5 = sg.children.find_by_name("Jumping")
      sg5.update_attributes!(:name => "Jumping Equipment")
      # create new categories
      ProductCategory.create(:name => "Bounce Houses", :parent => sg5)
      ProductCategory.create(:name => "Accessories", :parent => sg5)
      ProductCategory.create(:name => "Other", :parent => sg5)

      sg6 = sg.children.find_by_name("Racquet Sports")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => sg6)

      sg7 = sg.children.find_by_name("Team Sports")
      sg7.update_attributes!(:name => "Team Sports Equipment")
      # create new categories
      ProductCategory.create(:name => "Water Polo", :parent => sg7)
      ProductCategory.create(:name => "Swimming", :parent => sg7)
      ProductCategory.create(:name => "Other", :parent => sg7)


      # Sporting Goods Outdoor Recreation
      puts "Sporting Goods Outdoor Recreation"
      sgor = ProductCategory.roots.find_by_name("Sporting Goods Outdoor Recreation")

      sgor1 = sgor.children.find_by_name("Camping, Hiking, Backpacking")
      # create new categories
      ProductCategory.create(:name => "Gadgets", :parent => sgor1)
      ProductCategory.create(:name => "Camp Kitchen", :parent => sgor1)
      ProductCategory.create(:name => "Health and Safety", :parent => sgor1)
      ProductCategory.create(:name => "Other", :parent => sgor1)

      sgor2 = sgor.children.find_by_name("Cycling")
      sgor2.update_attributes!(:name => "Cycling and Accessories")
      # create new categories
      ProductCategory.create(:name => "Street & City Bikes", :parent => sgor2)
      ProductCategory.create(:name => "Other", :parent => sgor2)

      sgor3 = sgor.children.find_by_name("Golf")
      sgor3.update_attributes!(:name => "Golf and Accessories")
      # create new categories
      ProductCategory.create(:name => "Irons", :parent => sgor3)
      ProductCategory.create(:name => "Wedges", :parent => sgor3)
      ProductCategory.create(:name => "Other", :parent => sgor3)

      sgor4 = sgor.children.find_by_name("Equestrian")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => sgor4)

      sgor5 = sgor.children.find_by_name("Fishing")
      # create new categories
      ProductCategory.create(:name => "Rain Gear", :parent => sgor5)
      ProductCategory.create(:name => "Tackle Boxes & Fishing Bags", :parent => sgor5)
      ProductCategory.create(:name => "Float Tubes & Pontoons", :parent => sgor5)
      ProductCategory.create(:name => "Ice Fishing", :parent => sgor5)
      ProductCategory.create(:name => "Other", :parent => sgor5)

      sgor6 = sgor.children.find_by_name("Hunting")
      # create new categories
      ProductCategory.create(:name => "Hunting Clothing", :parent => sgor6)
      ProductCategory.create(:name => "Camo Bags and Backpacks", :parent => sgor6)
      ProductCategory.create(:name => "Knives and Tools", :parent => sgor6)
      ProductCategory.create(:name => "Hunting Decoys", :parent => sgor6)
      ProductCategory.create(:name => "Game & Trail Cameras", :parent => sgor6)
      ProductCategory.create(:name => "Other", :parent => sgor6)

      sgor7 = sgor.children.find_by_name("Motorsports")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => sgor7)

      sgor8 = sgor.children.find_by_name("Water Sports")
      # create new categories
      ProductCategory.create(:name => "Towables", :parent => sgor8)
      ProductCategory.create(:name => "Other", :parent => sgor8)

      sgor9 = sgor.children.find_by_name("Winter Sports")
      # create new categories
      ProductCategory.create(:name => "Dogsledding", :parent => sgor9)
      ProductCategory.create(:name => "Snowmobiling", :parent => sgor9)
      ProductCategory.create(:name => "Other", :parent => sgor9)


      # Toys and Games
      puts "Toys and Games"
      tg = ProductCategory.roots.find_by_name("Toys and Games")

      tg1 = tg.children.find_by_name("Games")
      # create new categories
      ProductCategory.create(:name => "Puzzles", :parent => tg1)
      ProductCategory.create(:name => "Card Games", :parent => tg1)
      ProductCategory.create(:name => "Interactive Games", :parent => tg1)
      ProductCategory.create(:name => "Magic", :parent => tg1)
      ProductCategory.create(:name => "Travel Games & Novelties", :parent => tg1)
      ProductCategory.create(:name => "Other", :parent => tg1)

      tg2 = tg.children.find_by_name("Outdoor Play Equipment")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => tg2)

      tg3 = tg.children.find_by_name("Toys")
      # create new categories
      ProductCategory.create(:name => "Bikes and Ride-Ons", :parent => tg3)
      ProductCategory.create(:name => "Action Figures", :parent => tg3)
      ProductCategory.create(:name => "Learning", :parent => tg3)
      ProductCategory.create(:name => "Stuffed Animals", :parent => tg3)
      ProductCategory.create(:name => "Arts and Crafts", :parent => tg3)
      ProductCategory.create(:name => "Electronics", :parent => tg3)
      ProductCategory.create(:name => "Other", :parent => tg3)


      # Vehicle and Parts
      puts "Vehicle and Parts"
      vp = ProductCategory.roots.find_by_name("Vehicle and Parts")

      vp1 = vp.children.find_by_name("Vehicles")
      # create new categories
      ProductCategory.create(:name => "Used Trucks and SUV's", :parent => vp1)
      ProductCategory.create(:name => "Vehicle Accessories", :parent => vp1)
      ProductCategory.create(:name => "Others", :parent => vp1)

      vp2 = vp.children.find_by_name("Car Audio and Video")
      # create new categories
      ProductCategory.create(:name => "Accessories", :parent => vp2)
      ProductCategory.create(:name => "Other", :parent => vp2)

      vp3 = vp.children.find_by_name("Tires and Tire Care")
      # update old categories
      vp3.children.find_by_name("Truckand SUV  Tires").update_attributes!(:name => "Truck and SUV Tires")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => vp3)

      vp4 = vp.children.find_by_name("Locking Systems and Monitoring")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => vp4)

      vp5 = vp.children.find_by_name("Mechanics and Specialty")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => vp5)


      # Health and Beauty
      puts "Health and Beauty"
      hb = ProductCategory.roots.find_by_name("Health and Beauty")

      hb1 = hb.children.find_by_name("Healthcare")
      # create new categories
      ProductCategory.create(:name => "Vitamins and Supplements", :parent => hb1)
      ProductCategory.create(:name => "Other", :parent => hb1)

      hb2 = hb.children.find_by_name("Personal Care")
      # create new categories
      ProductCategory.create(:name => "Shaving and Grooming", :parent => hb2)
      ProductCategory.create(:name => "Spa and Massage", :parent => hb2)
      ProductCategory.create(:name => "Other", :parent => hb2)

      hb3 = hb.children.find_by_name("Eye Care / Prodcuts")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => hb3)


      # Jewelry
      puts "Jewelry"
      jw = ProductCategory.roots.find_by_name("Jewelry")

      jw1 = jw.children.find_by_name("Womens Jewelry")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => jw1)

      jw2 = jw.children.find_by_name("Mens Jewerly")
      # create new categories
      ProductCategory.create(:name => "Money Clips", :parent => jw2)
      ProductCategory.create(:name => "Other", :parent => jw2)


      # Hardware
      puts "Hardware"
      hw = ProductCategory.roots.find_by_name("Hardware")

      hw1 = hw.children.find_by_name("Home Fencing")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => hw1)

      hw2 = hw.children.find_by_name("Plumbing")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => hw2)

      hw3 = hw.children.find_by_name("Roofing")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => hw3)

      hw4 = hw.children.find_by_name("Electrical")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => hw4)

      hw5 = hw.children.find_by_name("Painting and Wall Covering")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => hw5)

      hw6 = hw.children.find_by_name("Tools")
      # create new categories
      ProductCategory.create(:name => "Other", :parent => hw6)


      # Office Supplies
      puts "Office Supplies"
      os = ProductCategory.roots.find_by_name("Office Supplies")

      os1 = os.children.find_by_name("Filing and Organization")
      # create new categories
      ProductCategory.create(:name => "Metal and Wood Desktops", :parent => os1)
      ProductCategory.create(:name => "File Sorters and Organizers", :parent => os1)
      ProductCategory.create(:name => "Portable File Storage", :parent => os1)
      ProductCategory.create(:name => "Other", :parent => os1)

      os2 = os.children.find_by_name("General Supplies")
      # create new categories
      ProductCategory.create(:name => "Paper and Notebooks", :parent => os2)
      ProductCategory.create(:name => "Pens, Tape and Desk Supplies", :parent => os2)
      ProductCategory.create(:name => "Drives and Accessories", :parent => os2)
      ProductCategory.create(:name => "Furniture and Chairs", :parent => os2)
      ProductCategory.create(:name => "Copy and Print", :parent => os2)
      ProductCategory.create(:name => "Envelopes and Labels", :parent => os2)


      # Apparel Clothing Youth Girls
      puts "Apparel Clothing Youth Girls"
      acyg = ProductCategory.create(:name => "Apparel Clothing Youth Girls")

      acyg1 = ProductCategory.create(:name => "Activewear", :parent => acyg)

      ProductCategory.create(:name => "Shorts", :parent => acyg1)
      ProductCategory.create(:name => "Shirts and Pants", :parent => acyg1)
      ProductCategory.create(:name => "Sneakers", :parent => acyg1)
      ProductCategory.create(:name => "Sweatshirts", :parent => acyg1)
      ProductCategory.create(:name => "Compression Undergarments", :parent => acyg1)
      ProductCategory.create(:name => "Yoga Apparel", :parent => acyg1)
      ProductCategory.create(:name => "Socks", :parent => acyg1)
      ProductCategory.create(:name => "Shoes", :parent => acyg1)
      ProductCategory.create(:name => "Running Gear", :parent => acyg1)
      ProductCategory.create(:name => "Workout Clothes", :parent => acyg1)
      ProductCategory.create(:name => "Other", :parent => acyg1)

      acyg2 = ProductCategory.create(:name => "Outerwear", :parent => acyg)

      ProductCategory.create(:name => "Jackets and Parka's", :parent => acyg2)
      ProductCategory.create(:name => "Ski and Snow Gear", :parent => acyg2)
      ProductCategory.create(:name => "Hiking Books", :parent => acyg2)
      ProductCategory.create(:name => "Athletic Shoes", :parent => acyg2)
      ProductCategory.create(:name => "Winter Gear", :parent => acyg2)
      ProductCategory.create(:name => "Gloves and Mittens", :parent => acyg2)
      ProductCategory.create(:name => "Sweaters", :parent => acyg2)
      ProductCategory.create(:name => "Rain Gear", :parent => acyg2)
      ProductCategory.create(:name => "Long Underwear", :parent => acyg2)
      ProductCategory.create(:name => "Hats Gloves and Scarfs", :parent => acyg2)
      ProductCategory.create(:name => "Other", :parent => acyg2)

      acyg3 = ProductCategory.create(:name => "Sleepwear and Loungwear", :parent => acyg)

      ProductCategory.create(:name => "Pajamas", :parent => acyg3)
      ProductCategory.create(:name => "Nightgowns", :parent => acyg3)
      ProductCategory.create(:name => "Robes", :parent => acyg3)
      ProductCategory.create(:name => "Loungewear", :parent => acyg3)
      ProductCategory.create(:name => "Maternity", :parent => acyg3)
      ProductCategory.create(:name => "Slippers", :parent => acyg3)
      ProductCategory.create(:name => "Other", :parent => acyg3)

      acyg4 = ProductCategory.create(:name => "Swimwear", :parent => acyg)

      ProductCategory.create(:name => "One Piece", :parent => acyg4)
      ProductCategory.create(:name => "Shorts and Briefs", :parent => acyg4)
      ProductCategory.create(:name => "Two Piece", :parent => acyg4)
      ProductCategory.create(:name => "Cover-Ups", :parent => acyg4)
      ProductCategory.create(:name => "Wraps", :parent => acyg4)
      ProductCategory.create(:name => "Wetsuits", :parent => acyg4)
      ProductCategory.create(:name => "Bottoms and Tops", :parent => acyg4)
      ProductCategory.create(:name => "Sunglasses", :parent => acyg4)
      ProductCategory.create(:name => "Other", :parent => acyg4)


      # Apparel Clothing Youth Boys
      puts "Apparel Clothing Youth Boys"
      acyb = ProductCategory.create(:name => "Apparel Clothing Youth Boys")

      acyb1 = ProductCategory.create(:name => "Activewear", :parent => acyb)

      ProductCategory.create(:name => "Shorts", :parent => acyb1)
      ProductCategory.create(:name => "Shirts and Pants", :parent => acyb1)
      ProductCategory.create(:name => "Sneakers", :parent => acyb1)
      ProductCategory.create(:name => "Sweatshirts", :parent => acyb1)
      ProductCategory.create(:name => "Compression Undergarments", :parent => acyb1)
      ProductCategory.create(:name => "Socks", :parent => acyb1)
      ProductCategory.create(:name => "Shoes", :parent => acyb1)
      ProductCategory.create(:name => "Running Gear", :parent => acyb1)
      ProductCategory.create(:name => "Workout Clothes", :parent => acyb1)
      ProductCategory.create(:name => "Hiking Gear", :parent => acyb1)
      ProductCategory.create(:name => "Other", :parent => acyb1)

      acyb2 = ProductCategory.create(:name => "Outerwear", :parent => acyb)

      ProductCategory.create(:name => "Jackets and Parka's", :parent => acyb2)
      ProductCategory.create(:name => "Ski and Snow Gear", :parent => acyb2)
      ProductCategory.create(:name => "Hiking Books", :parent => acyb2)
      ProductCategory.create(:name => "Athletic Shoes", :parent => acyb2)
      ProductCategory.create(:name => "Winter Gear", :parent => acyb2)
      ProductCategory.create(:name => "Gloves and Mittens", :parent => acyb2)
      ProductCategory.create(:name => "Sweaters", :parent => acyb2)
      ProductCategory.create(:name => "Rain Gear", :parent => acyb2)
      ProductCategory.create(:name => "Long Underwear", :parent => acyb2)
      ProductCategory.create(:name => "Hats Gloves and Scarfs", :parent => acyb2)
      ProductCategory.create(:name => "Other", :parent => acyb2)

      acyb3 = ProductCategory.create(:name => "Sleepwear and Loungwear", :parent => acyb)

      ProductCategory.create(:name => "Pajamas", :parent => acyb3)
      ProductCategory.create(:name => "One Piece PJ's", :parent => acyb3)
      ProductCategory.create(:name => "Robes", :parent => acyb3)
      ProductCategory.create(:name => "Loungewear", :parent => acyb3)
      ProductCategory.create(:name => "Slippers", :parent => acyb3)
      ProductCategory.create(:name => "Other", :parent => acyb3)

      acyb4 = ProductCategory.create(:name => "Swimwear", :parent => acyb)

      ProductCategory.create(:name => "Board Shorts", :parent => acyb4)
      ProductCategory.create(:name => "Bottoms", :parent => acyb4)
      ProductCategory.create(:name => "Sunglasses", :parent => acyb4)
      ProductCategory.create(:name => "Flip Flops", :parent => acyb4)
      ProductCategory.create(:name => "Wetsuits", :parent => acyb4)
      ProductCategory.create(:name => "Surfing Gear", :parent => acyb4)
      ProductCategory.create(:name => "Other", :parent => acyb4)

    end
  end
end