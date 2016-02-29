
# Users
u1 = User.where(email: 'nigel@greenshoresdigital.com').first_or_create!(first_name: 'Nigel', last_name: 'Sheridan-Smith', password: 'PASSWORD')

# Website, collection, items
w1 = Website.where(slug: 'music').first_or_create!(name: 'Music', user: u1)
c1 = Collection.where(slug: 'cd').first_or_create!(name: 'CD collection', website: w1)
i1 = Item.where(slug: 'acd0001').first_or_create!(title: 'Regurgitator - Tu Plang', item_type: 'Audio CD', item_id: 'ACD_0001', collection: c1)