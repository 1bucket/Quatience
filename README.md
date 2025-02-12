# Quatience
by me

## What is this game?
The very first thought I had that inspired me to make this game was, "What if I combined Geometry Dash and the Google Chrome dinosaur game?" </p>
And that's exactly what I did.</p>

## How did I make this game?

### My goal
I aimed to merge the infinite scroller idea from the Chrome dinosaur game with the Geometry Dash's minimal aesthetic. I also intended to increase the difficulty by adding more complex obstacles than just rows of cacti and the occasional bird.</p>

### Execution of goal

#### Difficulty
To accommodate for a wide range in player proficiency, I created three categories of obstacles: easy, normal, and difficult. In terms of gamemode, I gave the player the option to choose from among Classic (steady progression from Easy -> Difficult), Easy, Medium, and Difficult, in which Easy, Medium, and Difficult only spawn obstacles from their corresponding categories. </p>

#### Terrain Components
The world's terrain was divided into tiles, which had a uniform length and height. These tiles were used as a building block to generate the ground (a sequence of tiles on the same y-level that stretched from the left side of the screen to the right side) and also to generate platforms upon which the character may jump. However, coming into contact with a platform from the side or from the bottom would destroy the character. Platforms may either be suspended midair (meaning if the platform is high enough, the player may choose to pass under it) or extruded from the ground (creating a sort of thick wall). </p>

Spikes, appearing as triangles, would instantly destroy your character upon contact. Spikes may extrude from the top of any tile, or may extrude from the bottom of a floating platform tile. Spikes and platforms were the primary terrain components in what I called "structures."</p>

#### Terrain Generation

At its core, a structure is essentially a collection of terrain components. For example, two  tiles connected horizontally at the ground level may be considered a structure. Four tiles horizontally connected at the ground level with a spike extruding from the top of the two middle tiles is also considered a structure.</p>

As established previously, there are three difficulties of obstacles that may generate. I created several different obstacles for each difficulty and adjusted the percent chance of a structure generating according to the current difficulty. Calls to add new structures to the world occur regularly during gameplay, and terrain that has passed the player (i.e. passed into the left side of the screen) are removed to keep from using too much memory.</p>


## Why did I make this?
Reason #1: It was my final project for AP Computer Science in high school. As the school year was winding down, I wanted to go all out on this project.</p>
Reason #2: I wanted to test my skills (and my newfound knowledge of physics) and see just how far I could go with my current knowledge and within the given timeframe. Then, I'd get some estimate of my limits and be able to better gauge what scope I want to aim for in future projects.</p>

## Big thanks
Thank you to Mr. Holmes for ingraining the idea of semantics into my head, and thank you to Ms. Novillo for showing us Processing and giving us a ton of practice.</p>
And thank you for reading this document. Hope you enjoy your stay.</p>