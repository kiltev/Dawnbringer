-- Perk List
perks = {
  [1]={
    remove={"(-2)"},
  },
  [2]={
    remove={"(-1)","(-1)"},
  },
  [3]={
    remove={"(-1)"},
    add={"(+0) poison"},
  },
  [4]={
    remove={"(-1)"},
    add={"(+0) poison"},
  },
  [5]={
    remove={"(+0)","(+0)"},
    add={"(+1)","(+1)"},
  },
  [6]={
    remove={"(+0)","(+0)"},
    add={"(+1)","(+1)"},
  },
  [7]={
    add={"(+1) (If an enemy died after this attack, (recover) one of your (icon4) items)"},
  },
  [8]={
    add={"(+1) (If an enemy died after this attack, (recover) one of your (icon4) items)"},
  },
  [9]={
    add={"(+1) (If an enemy died after this attack, (recover) one of your (icon4) items)"},
  },
  [10]={
    remove={"(+1)","(+1)"},
    add={"(+2)","(+2)"},
  },
  [11]={
    remove={"(+1)","(+1)","(+1)"},
    add={"(+1) (Add +1 (attack) if you used a (icon4) item this turn)","(+1) (Add +1 (attack) if you used a (icon4) item this turn)","(+1) (Add +1 (attack) if you used a (icon4) item this turn)"},
  },
  [12]={
    add={"(+2) (Add +1 (attack) for each negative condition the target has)"},
  },
  [13]={
    add={"(+2) (Add +1 (attack) for each negative condition the target has)"},
  },
  [14]={
    ignore=ClassApi.PerkType.IgnoreScenario,
    add={"(+1) rolling"},
  },
  [15]={
    --You may bring two (body) items to each scenario if at least one of them has (Cloak), (Robe) or (Cape) in its name.
    add={"Perk Reminder #15"},
  },
  [16]={
    --Once each scenario, one adjacent ally may use one of your (icon4) items during their turn without it becoming (loss)
    add={"Perk Reminder #16"},
  },
  [17]={},
  [18]={
    --During a long rest, you may (recover) one of your (icon4) items
    add={"Perk Reminder #18"},
  },
},
