let datas = require("./cryptos.json")

result = {}

function sort_tag(data){
    var tags={}
    Object.keys(data).forEach((x)=>{
        data[x]["tags"].forEach(tag => {
            if(tag in tags){
                tags[tag]+=1
            }else{
                tags[tag]=1
            }
        })
    })
    if(Object.keys(tags).length===1){
        var ret= {"name":tags[0],"children":[]}
        Object.keys(data).forEach((x)=>{
            ret["children"].push({"name":x,"value":100})
        })
        return ret
    }else{
        var tab_tags = Object.entries(tags).sort((a,b)=>(b[1]-a[1]))
        console.log(tab_tags)
        if(tab_tags.length===0){
            return data
        }
        var soustab={}
        Object.keys(data).forEach((x)=>{
            if (data[x]["tags"].includes(tab_tags[0][0])){
                soustab[x]=data[x]
                soustab[x]["tags"].splice(soustab[x]["tags"].indexOf(tab_tags[0][0]),1)
                delete data.x
            }
        })
        return {"name":tab_tags[0][0],"children":[sort_tag(soustab)]}
    }

}

let res = sort_tag(datas)

console.log(res)