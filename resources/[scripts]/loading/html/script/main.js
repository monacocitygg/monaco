let audio = new Audio();
var request = new XMLHttpRequest();
var count = 0;
function Main(){
    
    return{
        DiscordGuildId: '1210761770738917477', // Discord server ID
        DiscordInviteLink: 'https://discord.gg/monacogg',
        // DiscordInviteLink2: 'https://discord.gg/vapo',
        // DiscordInviteLink3: 'https://discord.gg/akamecity',
        musicAutoplay: true, // if the music should automaticly start.
        musicVolume: 0.01, // Set the volume that you like (0 = 0% ; 0.5 = 50% ; 1 = 100%)
        buttons:[
            {label: 'Home', selected: true},
            {label: 'Team', selected: false},
        ],
        musicList: [
            {label: 'Lavish',author: 'LilTjay',src: 'audio/audio.mp3'},
        ],
        
        // No touching here!!!!
        isMusicPlaying: false,
        musicOpen: false,
        currentSong: 0,
        listen() {
            if (this.musicAutoplay) {
                setTimeout(() => { this.play(); }, 100);
            }
        
            var request = new XMLHttpRequest();
            request.open('GET', 'https://discordapp.com/api/guilds/'+this.DiscordGuildId+'/widget.json', true);
            request.onload = () => {
                if (request.status >= 200 && request.status < 400) {
                    var data = JSON.parse(request.responseText);
                    this.memberCount = data.presence_count; // Atribui diretamente
                    //console.log('Membros ativos: ' + this.memberCount);
                } else {
                    //console.log('Falha ao acessar a API: ' + request.status);
                }
            };
        
            request.onerror = () => {
                console.error('Erro ao conectar com a API do Discord');
            };
        
            request.send();
        },
        selectBtn(select){
            this.buttons.forEach(function(button){
                button.selected = false;
            });
            return true;
        },
        play(){
            audio.src = this.musicList[this.currentSong].src;
            audio.load();
            audio.play();
            audio.volume = this.musicVolume;
            this.isMusicPlaying = true;
        },
        pause(){
            audio.pause()
            this.isMusicPlaying = false;
        },
        next(){
            if(this.isMusicPlaying){
                audio.pause()
            }
            if(this.currentSong < this.musicList.length-1){
                this.currentSong++;
            }else{
                this.currentSong = 0;
            }
            audio.src = this.musicList[this.currentSong].src;
            audio.load();
            audio.play();
            this.isMusicPlaying = true;
        },
        prev(){
            if(this.isMusicPlaying){
                audio.pause()
            }
            if(this.currentSong != 0){
                this.currentSong = this.currentSong-1;
            }else{
                this.currentSong = this.musicList.length-1;
            }
            audio.src = this.musicList[this.currentSong].src;
            audio.load();
            audio.play();
            this.isMusicPlaying = true;
        },
    }
}

window.onload = function() {
    var video = document.getElementById("buziosv");
    function fetchVideoAndPlay() {
        const xhr = new XMLHttpRequest()
        xhr.responseType = 'blob'
        xhr.onload = function () {
            const blob = xhr.response
            video.src = URL.createObjectURL(blob);
            video.play().then(() => {
                video.style.opacity = 1
                video.addEventListener("ended", function() {
                    video.currentTime = 0
                    video.play()
                })
            }).catch((e) => {
                video = document.getElementById("buziosv")
                video.load()
                fetchVideoAndPlay()
            });
        };
    
        xhr.open('GET', 'img/monacorp.mp4')
        xhr.send()
    }

    video.load()
    fetchVideoAndPlay()
}