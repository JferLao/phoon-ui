<style  scoped>
    .index-main{
        width:100%;
        position:absolute;
        top:0;
        bottom:0;
        left:0;
        right:0;
        background-color:#FFF;
        background-image:url("https://raw.githubusercontent.com/JferLao/Phoon-ui/main/examples/assets/images/background.png");
        background-repeat: no-repeat;
        background-size: cover;
        background-position: 50%;
        overflow: hidden;
        .index-container{
            width:50%;
            height:100%;
            .index-content{
                display:flex;
                jistify-content:center;
                flex-direction:column;
                .index-title{
                    position:relative;
                    display:inline-block;
                    img{
                        border-style:none
                    }
                    .index-image{
                        heigth:100px;
                    }
                }
            }
        }

    }
</style>

<template>
    <div>
        <div class="index-main">
            <div class="index-container">
                <div class="index-content">
                    <span class="index-title">
                        <img src="examples/assets/images/logo.jpg" alt="" class="index-image">
                    </span>
                    <h2><%= 1></h2>
                    <p><%= 2></p>
                </div>
            </div>
        </div>
    </div>
</template>