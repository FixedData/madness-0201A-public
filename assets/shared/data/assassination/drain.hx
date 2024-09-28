


function opponentNoteHit(n)
{
    if (game.health > 0.1 && (game.dad.getAnimationName().indexOf('-alt') == -1 || n.gfNote)) game.health -= 0.01 * game.healthLoss;
}