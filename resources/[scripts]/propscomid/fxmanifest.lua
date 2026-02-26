shared_script '@tables/ai_module_fg-obfuscated.lua'
shared_script '@tables/ai_module_fg-obfuscated.lua'



  
 ----
fx_version "cerulean"
game "gta5"
this_is_a_map "yes"
client_scripts {
	"@vrp/lib/utils.lua",
    "client.lua"
}
server_scripts {
	"@vrp/lib/utils.lua",
"server.lua",
}
files {
	"stream/*",
	'stream/*.ydr',
	'stream/*.ytyp',
	"interiorproxies.meta",
}
data_file "INTERIOR_PROXY_ORDER_FILE" "interiorproxies.meta"
data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'
-- data_file "TIMECYCLEMOD_FILE" "xee_news_timecycle.xml"
-- data_file "DLC_ITYP_REQUEST" "stream/ForestNorth/forest_n_slod.ydr"
-- data_file "DLC_ITYP_REQUEST" "stream/ForestNorth/forest_n_slod.ytyp"
-- data_file "DLC_ITYP_REQUEST" "stream/ForestSouth/forest_s_slod.ydr"
-- data_file "DLC_ITYP_REQUEST" "stream/ForestSouth/forest_s_slod.ytyp"
-- data_file "DLC_ITYP_REQUEST" "stream/creativeInteriores/creative_props.ydr"
-- data_file "DLC_ITYP_REQUEST" "stream/creativeInteriores/creative_props.ytyp"
-- data_file "DLC_ITYP_REQUEST" "stream/Sprays/sprays.ydr"
-- data_file "DLC_ITYP_REQUEST" "stream/Sprays/sprays.ytyp"
-- data_file "DLC_ITYP_REQUEST" "stream/Badges/v_badges.ydr"      
-- data_file "DLC_ITYP_REQUEST" "stream/Badges/v_badges.ytyp"      
-- data_file 'DLC_ITYP_REQUEST' 'stream/mah_lanca.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/mah_lanca.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/mah_pirulito.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/mah_pirulito.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/propsfood.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/propsfood.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/ravenay_cupcake.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/ravenay_cupcake.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/ravenay_cupcake2.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/ravenay_cupcake2.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/ravenay_cupcake3.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/ravenay_cupcake3.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/ravenay_cupcake4.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/ravenay_cupcake4.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/ravenay_icecreamcasca.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/ravenay_icecreamcasca.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_catmug.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_catmug.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_sushi.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_sushi.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_tayaki.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_tayaki.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_onigiri.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_onigiri.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_sashimi.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_sashimi.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_bento.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_bento.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_dango.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_dango.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_niguiri.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_niguiri.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_acaibowl.ydr'       
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_acaibowl.ytyp'       
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_tempura.ydr'    
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_tempura.ytyp'    
   
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_pudim.ydr'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_pudim.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/props.ydr'    
-- data_file 'DLC_ITYP_REQUEST' 'stream/props.ytyp'    
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_refeicao.ydr'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_refeicao.ytyp'    
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_pokoxinha.ydr'  
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_pokoxinha.ytyp'  
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_mamadeira.ydr'  
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_mamadeira.ytyp'    
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_frank.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_frank.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_mummy.ydr'  
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_mummy.ytyp'  
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_battie.ydr'  
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_battie.ytyp'  
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_polvo.ydr'  
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_polvo.ytyp'  
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_polvo2.ydr'    
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_polvo2.ytyp'         
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_angel.ydr'            
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_angel.ytyp'            
data_file 'DLC_ITYP_REQUEST' 'stream/bag_bunny.ydr'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_bunny.ytyp'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_cat.ydr'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_cat.ytyp'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_cow.ydr'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_cow.ytyp'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_dog.ydr'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_dog.ytyp'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_pig.ydr'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_pig.ytyp'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_pony.ydr'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_pony.ytyp'         
-- data_file 'DLC_ITYP_REQUEST' 'stream/wand_props.ydr'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/wand_props.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/hillary_foods.ydr'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/hillary_foods.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/offstoreprops_comida.ydr'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/offstoreprops_comida.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/propsfood.ydr'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/propsfood.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_marshmallow.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_marshmallow.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_icecream.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_icecream.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_maca.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_maca.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_milho.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_milho.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_pamonha.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_pamonha.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_pacoca.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_pacoca.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/xtudo.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/xtudo.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/xtudokids.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/xtudokids.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/cheesecake.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/cheesecake.ytyp'  
-- data_file 'DLC_ITYP_REQUEST' 'stream/pudim.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/pudim.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/dellvale.ydr'  
-- data_file 'DLC_ITYP_REQUEST' 'stream/dellvale.ytyp'  
-- data_file 'DLC_ITYP_REQUEST' 'stream/numberprop.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/numberprop.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/foodnos.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/foodnos.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/butterbeer.ydr' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/butterbeer.ytyp' 
-- data_file 'DLC_ITYP_REQUEST' 'stream/mamadeira.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/mamadeira.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_brownie.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_brownie.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_redvelvet.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_redvelvet.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/replaces/rojo_jblboombox.ydr'    
-- data_file 'DLC_ITYP_REQUEST' 'stream/replaces/rojo_jblboombox.ytyp'    
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_mamadeira2.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_mamadeira2.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/gnd_mamadeira_lazaro.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/gnd_mamadeira_lazaro.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bratzlight.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bratzlight.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/cafegelado.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/cafegelado.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/macaron.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/macaron.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/prop_penischocolate_ajna.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/prop_penischocolate_ajna.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/prop_vaginachocolate_ajna.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/prop_vaginachocolate_ajna.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_chococat.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_cinnamoroll.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/gnd_lol_metadatas.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_chococat.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_cinnamoroll.ydr'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_chococat.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_cinnamoroll.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_coconut.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_sorvete.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_sanduiche.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_mamadeira.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_pastel.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_paodequeijo.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_beijinho.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/gnd_acaraje_prop.ytyp'            
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_shrimp.ytyp'    
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_coxinha.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/bagdad_gatorade.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/gnd_lasanha_prop.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/gnd_moqueca_prop.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_mestrekame.ytyp'    
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_pipoca.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/thelittlemermaid.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_battie.ytyp'      
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_frank.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_mummy.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/gnd_orange_morango.ytyp'    
-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_unicorncup.ytyp'   
-- data_file 'DLC_ITYP_REQUEST' 'stream/gnd_salmao_prato.ytyp'   

data_file 'DLC_ITYP_REQUEST' 'stream/gnd_romantic_teddy.ytyp'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_gelo.ytyp'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_paozinho.ytyp'   
data_file 'DLC_ITYP_REQUEST' 'stream/bag_bear.ytyp'   
data_file 'DLC_ITYP_REQUEST' 'stream/mah_drop.ytyp'   
data_file 'DLC_ITYP_REQUEST' 'stream/p_shk_chimarrao.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bag_lhama.ytyp'

-- data_file 'DLC_ITYP_REQUEST' 'stream/gnd_banana_split.ytyp'   


-- data_file 'DLC_ITYP_REQUEST' 'stream/bag_crepe2_01.ytyp'   
 
-- data_file 'DLC_ITYP_REQUEST' 'stream/gnd_salad.ytyp'    

data_file 'DLC_ITYP_REQUEST' 'stream/bag_halloween7.ytyp'   

data_file 'DLC_ITYP_REQUEST' 'stream/props_leonmonster.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/prop_leoncap.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/prop_leonbananacat.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/prop_leondog.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/zBaldeFrango.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/zLimonada.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/zMarrom.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/zOvoBeacon.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/zPancake.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/zPretzels.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/zSucrilhos.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/zyogurtStrawberry.ytyp'


data_file 'DLC_ITYP_REQUEST' 'stream/luciferinallbabyrosa.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/luciferinallbabyazul.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/luciferinablue.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/afva_ellu_s.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/glam_ellu_afva.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/gndbonecodeneveanim.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/flowerstore_props_comidas_cool.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bag_macaron.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bag_mochi2.ytyp'


data_file 'DLC_ITYP_REQUEST' 'stream/zVKStore_EspCamarao.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/VkStore_Acaraje.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/VkStore_aguaCoco.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/zVKStore_CusCuz.ytyp'


file "stream/p_defilied_ragdoll_01_s.ydr"


data_file 'DLC_ITYP_REQUEST' 'stream/chanel_burguershotprops.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bag_bunny.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bag_bunny_01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bag_bunny_02.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bag_ovo.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bag_ovo_02.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bag_ovo_03.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/gotica_mirimfl.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_ratobeefl.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_ziggyfl.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_nanicafl.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/flowerstore_ursinhos_pascoa.ytyp'


data_file 'DLC_ITYP_REQUEST' 'stream/gnd_teddy_resort.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gnd_siri_plush.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gnd_ursinho_green.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gnd_plush_rola.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gnd_tourinho.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gnd_nalu_tucano.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/gnd_cupcake_gatinho.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_mamaeexclusivo.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/GN_annegablles.ytyp'

data_file 'DLC_ITYP_REQUEST' 'bouquet_valentines_kyndra_a.ytyp'

data_file 'DLC_ITYP_REQUEST' 'ajna_bearcouple_01.ytyp'

data_file 'DLC_ITYP_REQUEST' 'gotica_doutoragiraffa.ytyp'
data_file 'DLC_ITYP_REQUEST' 'gotica_testegravidezp.ytyp'
data_file 'DLC_ITYP_REQUEST' 'gotica_ultrassom.ytyp'
data_file 'DLC_ITYP_REQUEST' 'gotica_drpinguim.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/krakenstore_prop_tornozeleira.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/Ja_Cangaceiro.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/MariaBonita.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/Cangaceiro.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/espantalho.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/cacto_violao.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/matuto.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/matuta.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/cangaceiro1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/cangaceira.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/ajna_bearcam_01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/ajna_catcam_01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/ajna_giraffsign_01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/Tokyo.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ajna_camfluffy_01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/ajna_phonefluffy_01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/GN_teddyll.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/gotica_sucoabacaxi.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_bebidabee.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_rabada.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_pudimbee.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_paodemel.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_honeyshake.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_ovoprato.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_chapicao.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_capivara.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_honeyclub.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_banana.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_balaobee.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/dog_casquinha.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/Burguer_urso.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/Buguer_dog.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/batatinha.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/panda_burguer.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/Ted_burguer.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/vks_mdoce_01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/vks_mdoce_02.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/vks_mdoce_03.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/vks_mdoce_04.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/vks_pikaquente.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/vks_pirumelado.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/vks_sucpouha.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/SacolaCombo.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ajnaprop_bestdaddyb_01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/ajnaprop_bestdaddyg_01.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_lua.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_patricia.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/gerberas.ydr'

data_file 'DLC_ITYP_REQUEST' 'stream/gotica_catbranca.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_catbandido.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_catdoctor.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_catmecanico.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_catpolicial.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_catpreto.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/wave_labu02v2_prop.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/wave_labu03v2_prop.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/wave_labu04v2_prop.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/wave_labu07v2_prop.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/wave_labu08v2_prop.ytyp'


data_file 'DLC_ITYP_REQUEST' 'stream/Bobesponja.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/lula_molusco.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/patrick.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/siri_cascudo.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_viibolt.ytyp'


data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_dininha.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_loira.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_morena.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_Tigrinho.ytyp'


data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_alegria.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_ansiedade.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_inveja.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_medo.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_nojinho.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_raiva.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_tedio.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_tristeza.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_vergonha.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_dream_of_lights.ytyp'


data_file 'DLC_ITYP_REQUEST' 'stream/gotica_xepa.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_stitchamor.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_lilo.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_angelstich.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_angelamor.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/gotica_melodygrande.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_kuromigrande.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_hkgrande.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_cinnamongrande.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tesaodevaca.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_churrasquinho.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_coxinha.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_linguica.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_picanha.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_abacaxi.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_cervejaa.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_limonada.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_tonica.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/Vks_Angel.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/Vks_Charlie.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/Vks_Husk.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/Vks_Lulu.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/Vks_Nifty.ytyp'


data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_salsichao.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_lindinho.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_lindinha.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_macacao.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_florzinho.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_flozinha.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_docinhom.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_docinh.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_Bola.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_boo.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_henrry.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_mike.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_randal.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_sulivan.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_caixarosa.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_casar.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_namorar.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_love.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_teamo.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_ursonamorado.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_buzlaitir.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_dino.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_jessie.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_pocoto.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/miaushroomstore_wood.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/MS_hallowen.ydr'
data_file 'DLC_ITYP_REQUEST' 'stream/MS_hallowen.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/MS_zumbi.ydr'
data_file 'DLC_ITYP_REQUEST' 'stream/MS_zumbi.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/MS_biscoito.ydr'
data_file 'DLC_ITYP_REQUEST' 'stream/MS_biscoito.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/MS_espantalho.ydr'
data_file 'DLC_ITYP_REQUEST' 'stream/MS_espantalho.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/MS_zumbicao.ydr'
data_file 'DLC_ITYP_REQUEST' 'stream/MS_zumbicao.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/UrsoCapivaraEsqueleto.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/UrsoCapivaraFantasma.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/UrsoCapivaraFrankenstein.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/UrsoCapivaraHalloween.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/UrsoCapivaraVampiro.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/gotica_fantasmadoceshallowen.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_ursoskell.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/body.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/shifu.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/panda.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/oogway.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/mrping_.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/gotica_papainoelrena.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_ursopresentenatal.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/gotica_sapogg.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_romerebart.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_romernatal.ytyp'


data_file 'DLC_ITYP_REQUEST' 'stream/gotica_hkfrionatal.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_hkstar.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_hkrena.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_hkrainhaneve.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gotica_hkelfo.ytyp'