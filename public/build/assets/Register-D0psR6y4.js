import{T as p,o as c,c as w,w as n,a,u as s,Z as _,b as t,d,j as g,n as V,e as y}from"./app-CTt1UjVF.js";import{_ as v}from"./GuestLayout-CEQXYKEX.js";import{_ as l,a as m,b as i}from"./TextInput-vk5B30E7.js";import{P as b}from"./PrimaryButton-Deb9_swA.js";import"./ApplicationLogo-C88jWaU2.js";import"./_plugin-vue_export-helper-DlAUqK2U.js";const x={class:"mt-4"},k={class:"mt-4"},h={class:"mt-4"},q={class:"flex items-center justify-end mt-4"},j={__name:"Register",setup(B){const e=p({name:"",email:"",password:"",password_confirmation:""}),u=()=>{e.post(route("register"),{onFinish:()=>e.reset("password","password_confirmation")})};return(f,o)=>(c(),w(v,null,{default:n(()=>[a(s(_),{title:"Register"}),t("form",{onSubmit:y(u,["prevent"])},[t("div",null,[a(l,{for:"name",value:"Name"}),a(m,{id:"name",type:"text",class:"mt-1 block w-full",modelValue:s(e).name,"onUpdate:modelValue":o[0]||(o[0]=r=>s(e).name=r),required:"",autofocus:"",autocomplete:"name"},null,8,["modelValue"]),a(i,{class:"mt-2",message:s(e).errors.name},null,8,["message"])]),t("div",x,[a(l,{for:"email",value:"Email"}),a(m,{id:"email",type:"email",class:"mt-1 block w-full",modelValue:s(e).email,"onUpdate:modelValue":o[1]||(o[1]=r=>s(e).email=r),required:"",autocomplete:"username"},null,8,["modelValue"]),a(i,{class:"mt-2",message:s(e).errors.email},null,8,["message"])]),t("div",k,[a(l,{for:"password",value:"Password"}),a(m,{id:"password",type:"password",class:"mt-1 block w-full",modelValue:s(e).password,"onUpdate:modelValue":o[2]||(o[2]=r=>s(e).password=r),required:"",autocomplete:"new-password"},null,8,["modelValue"]),a(i,{class:"mt-2",message:s(e).errors.password},null,8,["message"])]),t("div",h,[a(l,{for:"password_confirmation",value:"Confirm Password"}),a(m,{id:"password_confirmation",type:"password",class:"mt-1 block w-full",modelValue:s(e).password_confirmation,"onUpdate:modelValue":o[3]||(o[3]=r=>s(e).password_confirmation=r),required:"",autocomplete:"new-password"},null,8,["modelValue"]),a(i,{class:"mt-2",message:s(e).errors.password_confirmation},null,8,["message"])]),t("div",q,[a(s(g),{href:f.route("login"),class:"underline text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-100 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 dark:focus:ring-offset-gray-800"},{default:n(()=>[d(" Already registered? ")]),_:1},8,["href"]),a(b,{class:V(["ms-4",{"opacity-25":s(e).processing}]),disabled:s(e).processing},{default:n(()=>[d(" Register ")]),_:1},8,["class","disabled"])])],32)]),_:1}))}};export{j as default};
