#' Damage Per Round
#'
#' @param M Monster
#' @param A Attack: Attack bonus (Proficiency + STR/DEX).
#' @param D Damage: Average dice roll (e.g., d8 = 4.5).
#' @param B Bonus: STR/DEX.
#' @param C Critical: Critical hit rolls (Usually 20, sometimes lower).
#' @param adv Advantage: `NA`, `TRUE`, or `FALSE.`
#' @seealso <https://rpgbot.net/dnd5/characters/damage-per-round.html>
#' @examples
#' dnd_dpr(15, 8, 4.5, 5)
#' @export
dnd_dpr <- function(M, A, D, B, C = 20, adv = NA) {
  C = 1/C
  if (is.na(adv)) {
    H = 1 - ((M - A - 1)/20)
    C * D + H * (D + B)
  } else if (isTRUE(adv)) {
    Ha = 1 - ((M - A)/20)^2
    Ca = 1 - (1-C)^2
    Ca * D + Ha * (D + B)
  } else if (isFALSE(adv)) {
    Hd = ((20 - M + A)/20)^2
    Cd = C^2
    Cd * D + Hd * (D + B)
  }
}
