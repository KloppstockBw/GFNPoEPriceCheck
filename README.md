# ![Awakener's Orb](https://web.poecdn.com/image/Art/2DItems/Currency/TransferOrb.png) Geforce NOW bridge for Awakened PoE Trade

## Usage

| F5 | F6 | F7 | F11 |
|-----|------|--------|----------|
| goto hideout | price check | open steam overlay | force close script |

### Requirements

- GFNPoEPriceCheck.exe

- Awakened POE Trade
  https://github.com/SnosMe/awakened-poe-trade

- Path of exile for **Steam** in Geforce NOW (GGG Version does not work) 

- (Alternatively to the GFNPoEPriceCheck.exe you can run the script GFNPoEPriceCheck.au3 then you need Autoit https://www.autoitscript.com/site/autoit/downloads/ ) 


### Features

- No need to change Awakened PoE Trade settings
- Copy Item Details in background
- config file in documents/mygames/Path Of EXILE containing
  - URL to google.docs
  - Mouse position to paste item details in GFN
  - 
- more to come

## Install
1. Create a docs.google.com document and share it to everyone so it shows /edit at the end in URL.
2. Change default Website in Steam overlay to the docs.google.com URL .
3. Set Steam overlay default key to F7
4. You dont need to change settings in Awakened PoE Trade anymore. If you changed the Window title then please revert back to "Path of Exile"
5. Run script. 
   The first price check after running the script takes 10 sek because the docs.google.com takes some time to be loaded inside gfn  
