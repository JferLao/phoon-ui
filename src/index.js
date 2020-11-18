/* Automatically generated by './build/bin/build-entry.js' */

import Button from '../packages/button/index.js';
import Scrollbar from '../packages/scrollbar/index.js';
import locale from 'phoon-ui/src/locale';

const components = [ 
     Button,
 Scrollbar
];

const install = function(Vue, opts = {}){
    locale.use(opts.locale);
    locale.i18n(opts.i18n);

    components.forEach(component => {
        Vue.component(component.name,component);
    });
};

if(typeof window !== 'undefined' && window.Vue){
    install(window.Vue)
}
    
// 导出版本号、Install方法（插件）和一些功能
export default {
    version:'1.0.0',
    locale:locale.i18n,
    install,
     Button,
 Scrollbar
};
