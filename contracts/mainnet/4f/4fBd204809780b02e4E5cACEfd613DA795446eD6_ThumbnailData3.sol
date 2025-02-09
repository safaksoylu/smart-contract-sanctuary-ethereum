// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IData.sol";

contract ThumbnailData3 is IData {
    function data()
        public
        pure
        returns (bytes memory)
    {
        return hex"4e4c6f756772484e424831575a53643147446345796c30482f56655364334c37724e663171784b784737357776495543497657555669337173577245395173436d6b4341437a65345757376f675143344c6d76433631427763477845316c39776f5244775a715a59774177354243473035353142514261625169574f754559684342426752753566644f6837313044634f4a42596c596a643834722b57696833574c6571786173543146647a7764534b73547047532b5564555142695653734a4c534141517376754b7861413439436e6731432f714e334c37706f42464d376e4761396e623948454c46596a643834516947694b6f547463796a456b4f4a4b6d3477675051707343346941394669656f5677564336504d6f7a4e4b337168454e61546f714578356c474c6e506956434c684a62477174617767366845416c34436753487758694c4369774831546f76416d56694f6c6253577345584f754171792b367a5839617356694e337a6865513157526766724b763549523953566761737876565a542b6c586d72387036685a6f36465a6e5a5a627137433477516956466a504a3878545130536338443843724c37724f663171756356694e307a5952434b4441484342674b32683446686a4171694454695446456c305978516f3569455956577449492b6944414841677746567254454a74486f55326a304b326470385978456b476741786b45476b45786d4673687a42414143536252364646725162646b4a6b723347774962644c357a32526b787355654a376f6d724c37724e663171387857492f63416b6d774253626377572f564d44576934564754654b6b3743764c37724e66317138785749715930385a74436f32364b6a626f714e75696f32364a6a644578756959335255626446524d7377436145304a6f51434151434151434154516d684d416269516d417538304b3747684e424c6a45706a644b73767573312f5772465969727a6c5752334475587a50776d6b6c4f486f75426e355234684a315a6b3262765863792b367a583955517356694b764f666747414156396e703848675a696d677578524a71384c3547713453356c474a63596e63792b367a583956744b347245564e4f796156776a7a41473852464f51496f785950674e4a4b63432b344c685a67464a716678494b31576b515030526b3262765864792b3457612f7169735373525532495074442b675532457950786f735a2b536d427a7355485063684f4d494c414771546d58715a4a5879746a39555975635354753566645a722b74574b78465839792f6f45496768546166436667795a4467474a785449737570424e70514a4a54326c39774e67565073692b435a74456d416949706f4345484e6d3547594578555975635a68446a636a5a7850374465792b367a5839613852562f645036436f6568516d4e3845555173486d5167416941324639366f6d305458473631456b31574d346a56613768434a67692b4b38413849556d7361537258474f396c39316d7636313469722b35663046593432627768524377655a434143744a526d31774e594156727a2b425565436a6b50576f53765677526d3769663247343678576d724c37685a722b746549712f75583942754467656444754169696166754b4141466771756b4541514979784367324b2b55515672694172476742486a6477737145533477434149617a69646935474141696a346a7557784b744171792b3457612f7258694b76376c2f51626c684345326d465267424e78774345476756476349424f675843574b6b495172456d43413954556664736b332f74513936386659303979766d656a4e387a36566d415257716d53596d724c37724e66315542366d724556582b304f3644637551354f71655775463454514b5345515259364374526a41384178526a45547175434d326b53786972544d6f38627878636d31434c516542766d63725844695568736c7856684d472b6c5a736d7244554c7742566c39316d7636315554734a795432734968346a4a55376e4f775942416655714f79666148414537746a684243625351554559426844747536534a62524e4f764a66514b304b3849576c43516d56594249596c474c6e474b4d474e455875774345474e4547747743744a4152346e67412f346a634d6861724361686152566c39316d763631556a68366d5056456b6b696457652f6f4554756a7844692b696b4e6d5a584377546563416842676b3049524b6e435a7274644d6f2b366f7a41637a6968456b7162524e37764d354351744b7361646f2f5248686a42766f4b78565a755a66645a722b74574b78465839772f6f466773647a36657164784f3850726555776b4a734d45324a51385569726e47432b714d4b52346e7962562f56654f492b555949524a516959544b50764b58684849586d76454971784463792b367a5864565252357843785749717a333942555a41316a3052494c343749354b62585132454a776e5541393937726847344b594551333171502b497877434d584f4d554f4d2f77424e702f324b4d5353704f6349416f773262565a5942674b3759696f5634315a66645a727571644b4741574b78465765376f4b686161782f673375552b4434792b7138544b5145517163473376646746454d413449326e2b52586d4b6b30576f2b356f6a42764d346f65376165456559314467624d6c434141566a7753342b6c6471746a763566645a7275714d6c6973525666547536436f5831434c525a7a356c465463536841754d6e594c786c6b795648594a6a50356a69655349444743614553357964436c70427845584e5268524d6d397962733051345744305443524552756b67415954713872304c465972706d713765792b367a58645534672b69785749717a6e64425834415a382b53454b7849497759444d346e424e4457584f374657456767716234515a4730716236523054674176413378487a4f785566306d6e3870674746647a6e4932685778512b426c393166544f4770526442736856694b733533516235325733464e673044686146346a417551686953675377485a6f32692f6d6944545048765859667843744a513575356e6375706579507773767573782f56467739437356694b733133516277693058596c465461424d38304473346f51633454516a37565343513867527463454f42696b42755a7736464434575833437a5839613852566d75364373376e39536b76386f764b4d474478764e35566b693434414a6763614e703143744b624546346d72684d346e646148504a39323034346f784a333778586c397773352f56415643413268566d6e666d35317071414e4d2f384a77634c43374571304f495462726345596a634d474d4553724c476a416235676a586c39316d4f4a2b70524b784b784654774361516f78472f6166417a7555346d6c66455277434d6d6d4f715a4d6d4d61724e772b37595a6e452f41755746655833576137716f61495163313031694b764d555a51693275395752714d684d6c475a7174634941627a76655047672b4c6c39316d763631446959414b546d33465969727a46584f466477566756684b4d68616354756975775749784a507863767573312f564241467268416733676f78613134325479713878714d32717756435a5239546a766c45427531416e6b553768456773566366695a666458306a75714e5169396e473059777571387871774561724d4b6a766d3270304162797269727a38544c377130306a75714a6857506455704a484a3134586d4e575756544552757552446d4841514952753363503265583357593647716f326b77744e513462497130694c44673457464e67357279434d434e307a61414475334f4e654f2f65492f42792b367a4431514771744d675634695a4c424332542f573437746a675275324f41503743595746575833576137716956614a6f7941586741674279516931776756635a4845626d4f37665239442b787871792b367a5864567366577073432b307132476b51767036496364482b57376c307a55454b734866732f4a335761377169494750576f5267596f4541572b6751675264554f4238322f387261434461455974685869764d6668582f427659353335415761377275435a74526d2b7a6b46593565495459656535593462513951686458632f396c6556594b4b412b68437a58395530457a2b614639526d6256474e30563454424362624661687775385849317769463458734246666e48776a61506758425a66634c4e663154345647514a4b775242494b4d513253457243684a7756725443732f77424f6b49486f5a312b59667338767573312f56527348536f54734b7834755a583155397151433947684141334963544a4f357472734e4c41665156346a3968356138767573312f56594e4f6f72645936537473484d713047314168725a414b545146416772776d62547971504348423274664c396e6c397773312f5659416143737a4258685945322b5a545278455455746f6668574778446a624e76384178556a64552b6a4f3049454572326b416e4230463752526767536358436139706f6954437877564b7a5655724e56537331564b7a5655724e56544d3143706d61716c5a7171526d71704761716b627171527571704736716b627171527571704736716b6272566c39304a6671763637746a68506b464a676d6652415175484a656151586a6841564433644b5a386e66747270364c4c37724e663154584549455346643638526d356549474252675262364b77495368416f52613755466263527a573371672f5662657132395674367262315733717476566265713239567436726231516671747656626571323956743672623157337176314e56743672616952435a575937716e4341736b7342755769314478544e56726972545a555242706853434566517037667443653337516e742b304a37667443653337516e742b304a37667443653337516e742b304a37667443653337517151666146534437517155666146536a37517151666146534437517151625a61436545576c55672b304a77682f694538666146534437517645346b6e36714b756c755831334774735775424247494b6d4c576e45596f4966466b3346416b346c574141436f51677743484f394e41414e675542466138674531354d4a6b4172437357626e577671704f59527a694373534c4176614851634c78464f6a3941746e375167333751467379506c43325a2f784332622f6c4679686f45526f453637414b476752452b51554e416f5343356f7a4a5274644d6a31714e7330346b6b525163544b414a524b2f396b3d";
    }
}