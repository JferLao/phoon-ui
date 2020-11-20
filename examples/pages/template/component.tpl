<template>
    <ph-scrollbar class="page-component__scroll" ref="componentScrollBar">
        <div class="page-container page-component">
            <ph-scrollbar class="page-component__nav">
                <sider-nav :data="navsData[lang]" :base="`/${ lang }/component`"></sider-nav>
            </ph-scrollbar>
            <div class="page-component__content">
                <router-view class="content"></router-view>
                
            </div>
        </div>
    </ph-scrollbar>
</template>
<script>
    import navsData from '../../nav.config.json';
    import bus from '../../bus';
    import { throttle } from 'throttle-debounce';
    export default {
        data() {
      return {
        lang:this.$route.meta.lang,
        navsData,
        scrollTop:0,
        showHeader:true,
        componentScrollBar :null,
        componentScrollBoxElement:null
      };
    },
    watch:{
      '$route.path'(){
        this.componentScrollBox.scrollTop=0;
        this.$nextTick(()=>{
          this.componentScrollBar.update();
        });
      }
    },
    methods:{
        /* 在mounted钩子里给链接跳转添加基础路由 */
        renderAnchorHref() {
        if (/changelog/g.test(location.href)) return;
        const anchors = document.querySelectorAll('h2 a,h3 a,h4 a,h5 a');
        const basePath = location.href.split('#').splice(0, 2).join('#');

        [].slice.call(anchors).forEach(a => {
          const href = a.getAttribute('href');
          a.href = basePath + href; //路径上添加锚点
        });
      },

       /* 点击锚跳转到最顶端 */
      goAnchor() {
        if (location.href.match(/#/g).length > 1) {
          const anchor = location.href.match(/#[^#]+$/g);
          if (!anchor) return;
          const elm = document.querySelector(anchor[0]);
          if (!elm) return;

          setTimeout(_ => {
            this.componentScrollBox.scrollTop = elm.offsetTop;
          }, 50);
        }
      },
      handleScroll() {
        const scrollTop = this.componentScrollBox.scrollTop;
        if (this.showHeader !== this.scrollTop > scrollTop) {
          this.showHeader = this.scrollTop > scrollTop;
        }
        if (scrollTop === 0) {
          this.showHeader = true;
        }
        if (!this.navFaded) {
          bus.$emit('fadeNav');
        }
        this.scrollTop = scrollTop;
      }
    },

    computed: {
      showBackToTop() {
        return !this.$route.path.match(/backtop/);
      }
    },
    created() {
      bus.$on('navFade', val => {
        this.navFaded = val;
      });
    },
    mounted(){
        this.componentScrollBar = this.$refs.componentScrollBar;
        this.componentScrollBox = this.componentScrollBar.$el.querySelector('.ph-scrollbar__wrap');
        this.throttledScrollHandler = throttle(300, this.handleScroll);
        this.componentScrollBox.addEventListener('scroll', this.throttledScrollHandler);
        this.renderAnchorHref();
        this.goAnchor();
        document.body.classList.add('is-component');
    },
    destroyed(){
        document.body.classList.remove('is-component');
    },
    beforeDestroy() {
        this.componentScrollBox.removeEventListener('scroll', this.throttledScrollHandler);
    },
    beforeRouteUpdate(to, from, next) {
      next();
      setTimeout(() => {
        const toPath = to.path;
        const fromPath = from.path;
        if (toPath === fromPath && to.hash) {
          this.goAnchor();
        }
        if (toPath !== fromPath) {
          document.documentElement.scrollTop = document.body.scrollTop = 0;
          this.renderAnchorHref();
        }
      }, 100);
    }
};
</script>


<style>
    .page-component__scroll {
        height:calc(100% - 80px);
        margin-top:80px;

        > .ph-scrollbar__wrap{
            overflow-x:auto;
        }
    }
    .page-component {
        box-sizing:border-box;
        height:100%;

    &.page-container {
      padding: 0;
    }

        .page-component__nav{
            width:240px;
            position:fixed;
            top:0;
            bottom:0;
            margin-top:80px;
            transition:padding-top .3s;

            > .ph-scrollbar__wrap {
                height:100%;
                overflow-x:auto;
            }

            &.is-extended {
                padding-top:0;
            }
        }

        .side-nav {
      height: 100%;
      padding-top: 50px;
      padding-bottom: 50px;
      padding-right: 0;

      & > ul {
        padding-bottom: 50px;
      }
    }
    .page-component__content {
      padding-left: 270px;
      padding-bottom: 100px;
      box-sizing: border-box;
    }
    .page-component__content {
      padding-left: 270px;
      padding-bottom: 100px;
      box-sizing: border-box;
    }

    .content {
      padding-top: 50px;

      > {
        h3 {
          margin: 55px 0 20px;
        }

        table {
          border-collapse: collapse;
          width: 100%;
          background-color: #fff;
          font-size: 14px;
          margin-bottom: 45px;
          line-height: 1.5em;

          strong {
            font-weight: normal;
          }

          td, th {
            border-bottom: 1px solid #dcdfe6;
            padding: 15px;
            max-width: 250px;
          }

          th {
            text-align: left;
            white-space: nowrap;
            color: #909399;
            font-weight: normal;
          }

          td {
            color: #606266;
          }

          th:first-child, td:first-child {
            padding-left: 10px;
          }
        }

        ul:not(.timeline) {
          margin: 10px 0;
          padding: 0 0 0 20px;
          font-size: 14px;
          color: #5e6d82;
          line-height: 2em;
        }
      }
    }
    }

    @media (max-width:768px){
        .page-component{
            .page-component__nav{
                width:100%;
                position:static;
                margin-top:0;
            }
            .side-nav{
                padding-top:0;
                padding-left:50px;
            }
            .page-component__content {
        padding-left: 10px;
        padding-right: 10px;
      }
      .content {
        padding-top: 0;
      }
      .content > table {
        overflow: auto;
        display: block;
      }
        }
    }
</style>