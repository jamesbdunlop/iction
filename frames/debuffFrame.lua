local iction = iction
iction.ictDeBuffColumnData = { uiType = "Frame",
                                uiName = "tmp",
                                nameAttr = "tmp",
                                uiInherits = nil,
                                userPlaced = true,
                                movable = true,
                                enableMouse = false,
                                SetClampedToScreen = true,
                                w = iction.bw+5,
                                h = iction.bh+5,
                                bgCol = {r = 0, g = 0, b= 0, a = 0.25},
                                strata = "MEDIUM",
                                textures = { [0] = nil,
                                             [1] = {name = nil, allPoints = true, level = "ARTWORK",
                                                    texture= "Interface\\ChatFrame\\ChatFrameBackground",
                                                vr = 1, vg = 1, vb = 1, va = 0.25 }
                                            },
                                pointPosition = {point = "BOTTOM",
                                         relativeTo = nil,
                                         relativePoint = "CENTER",
                                         x = -2, y = 5},
                                }
