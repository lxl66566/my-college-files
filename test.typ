#let get_text(knt) = {
  let temp = knt.at("body", default: false)
  if temp == false { temp = knt.at("text") }
  temp
}
#let get_text2(knt) = {
  knt.at("body", default: knt.at("text", default: "anything"))
}
#let get_text3(knt) = {
  knt.at("body", default: knt.at("text"))
  // error: content does not contain field "text" and no default value was specified
}
#get_text([*20*])

#get_text([20])

#get_text2([*20*])

#get_text2([20])

// #get_text3([*20*])

// #get_text3([20])