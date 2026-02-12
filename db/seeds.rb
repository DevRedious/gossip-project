require "faker"

Like.destroy_all
Comment.destroy_all
PrivateMessageRecipient.destroy_all
PrivateMessage.destroy_all
JoinTableGossipTag.destroy_all
Gossip.destroy_all
Tag.destroy_all
User.destroy_all
City.destroy_all

puts "Base de données nettoyée."

# --- VILLES ---
10.times do
  City.create!(
    name: Faker::Address.city,
    zip_code: Faker::Address.zip_code
  )
end
puts "10 villes créées."

# --- UTILISATEURS ---
10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    email: Faker::Internet.email,
    age: rand(18..70),
    city: City.all.sample
  )
end
puts "10 utilisateurs créés."

# --- GOSSIPS ---
20.times do
  Gossip.create!(
    title: Faker::Lorem.sentence(word_count: 3),
    content: Faker::Lorem.paragraph(sentence_count: 4),
    user: User.all.sample
  )
end
puts "20 gossips créés."

# --- TAGS ---
10.times do
  Tag.create!(title: "##{Faker::Lorem.word}")
end
puts "10 tags créés."

# --- LIEN GOSSIP / TAG (chaque gossip a au moins un tag) ---
Gossip.find_each do |gossip|
  tags = Tag.all.sample(rand(1..3))
  tags.each do |tag|
    JoinTableGossipTag.create!(gossip: gossip, tag: tag)
  end
end
puts "Tags assignés aux gossips."

# --- MESSAGES PRIVÉS (expéditeur + un ou plusieurs destinataires) ---
15.times do
  pm = PrivateMessage.create!(
    content: Faker::Lorem.paragraph(sentence_count: 2),
    sender: User.all.sample
  )
  recipients = User.where.not(id: pm.sender_id).sample(rand(1..3))
  recipients.each do |recipient|
    PrivateMessageRecipient.create!(private_message: pm, recipient: recipient)
  end
end
puts "Messages privés créés."

# --- COMMENTAIRES (sur gossips et commentaires de commentaires) ---
# D'abord des commentaires sur des gossips
12.times do
  Comment.create!(
    content: Faker::Lorem.paragraph(sentence_count: 2),
    user: User.all.sample,
    commentable: Gossip.all.sample
  )
end
# Puis des commentaires de commentaires (réponses à des commentaires existants)
8.times do
  parent_comment = Comment.all.sample
  Comment.create!(
    content: Faker::Lorem.sentence(word_count: 6),
    user: User.all.sample,
    commentable: parent_comment
  )
end
puts "20 commentaires créés (dont commentaires de commentaires)."

# --- LIKES (sur gossips ou commentaires au hasard) ---
likes_count = 0
while likes_count < 20
  likeable = [ Gossip.all.sample, Comment.all.sample ].sample
  user = User.all.sample
  next if Like.exists?(user: user, likeable: likeable)

  Like.create!(user: user, likeable: likeable)
  likes_count += 1
end
puts "20 likes créés. Seed terminé."
