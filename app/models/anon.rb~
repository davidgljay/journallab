class Anon < ActiveRecord::Base

belongs_to :user, :class_name => "User"
belongs_to :paper, :class_name => "Paper"

validates :name, :presence => true
validates :user_id, :uniqueness => {:scope => [:paper_id] } 


# Functionality related to semin-anonymous names for users
  def generate

    animals = ["Aardvark","Alligator","Buffalo","Ant","Anteater","Antelope","Ape","Armadillo","Donkey","Baboon","Badger","Barracuda","Bat","Bear","Beaver","Bee","Bison","Boar","Buffalo","Butterfly","Camel","Caribou","Cat","Caterpillar","Cow","Chamois","Cheetah","Chicken","Chimpanzee","Cobra","Cormorant","Coyote","Crab","Crane","Crocodile","Crow","Deer","Dog","Dogfish","Dolphin","Donkey","Dove","Dragonfly","Duck","Dugong","Eagle","Echidna","Eel","Eland","Elephant","Elephant seal","Elk","Falcon","Ferret","Finch","Fly","Fox","Frog","Gaur","Gazelle","Gerbil","Giraffe","Gnu","Goat","Goose","Gorilla","Guanaco","Guinea fowl","Guinea pig","Gull","Hamster","Hare","Hawk","Hedgehog","Heron","Hippopotamus","Hornet","Horse","Human","Hyena","Iguana","Jackal","Jaguar","Jellyfish","Kangaroo","Koala","Komodo dragon","Kouprey","Kudu","Lark","Lemur","Leopard","Lion","Llama","Lobster","Lyrebird","Magpie","Mallard","Manatee","Meerkat","Mink","Mole","Monkey","Moose","Mosquito","Mouse","Mule","Narwhal","Nightingale","Okapi","Oryx","Ostrich","Otter","Owl","Ox","Oyster","Panda","Panther","Partridge","Peafowl","Pelican","Penguin","Pigeon","Platypus","Pony","Porcupine","Quelea","Rabbit","Raccoon","Ram","Raven","Reindeer","Rhinoceros","Salamander","Sea lion","Seahorse","Seal","Seastar","Shark","Sheep","Shrew","Snail","Snake","Spider","Squid","Squirrel","Swan","Tapir","Tiger","Toad","Turkey","Turtle","Walrus","Water Buffalo","Whale","Wolf","Wombat","Yak","Zebra"]

# Replace with en file, whicn I get around to centralizing it like I should.
    colors = User.new.colors
   
    self.name = colors[rand(colors.length - 1)] + ' ' + animals[rand(animals.length - 1)]
    self.save
  end

end
