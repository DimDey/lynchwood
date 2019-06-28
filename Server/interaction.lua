interaction = {
    objects = {}, -- массив с данными об интерактивных объектах
    objects_meta = { -- метатаблица массива выше
        __call = function(self,element,funClick)
            local gelement = createElement("int-obj")
            setElementID(gelement,#interactive.objects+1)
            setElementParent(element,gelement)
            
            local object = {
                intEl = element,
                element = gelement,
                onClick = funClick
            }

            interactive.objects[#interactive.objects+1] = object
            local link = interactive.objects[#interactive.objects]
            return link
        end;
    }
}
setmetatable(interactive.objects,interactive.objects_meta);