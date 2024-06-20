SavePartyToSwap:
; Save party to swap later
	push bc
	push de
	push hl
	xor a
	ld [wSwapBytes], a
	call CopyOrSwapBackupData
	pop hl
	pop de
	pop bc
	ret

SwapTeams:
; Swap saved team with enemy trainer
	push bc
	push de
	push hl

	ld a, 1
	ld [wSwapBytes], a

	call CopyOrSwapBackupData ; restore original team, backup current team
	call CopyOrSwapTeamData
	callfar HealParty ; heal knocked out enemy team

	pop hl
	pop de
	pop bc
	ret

RestoreSwappedTeam:
; Restore team which has previously been swapped
; Heal the restored team if the player is not blacked out
	push bc
	push de
	push hl

	call AnyPartyAlive
	push de

	ld a, 1
	ld [wSwapBytes], a
	call CopyOrSwapTeamData
	call CopyOrSwapBackupData ; restore team from battle end

	pop de
	ld a, d
	and a
	jr nz, .return

; knock out party if player lost
	ld a, [wPartyCount]
	ld e, a
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - wPartyMon1 - 1
	xor a
.knockoutPartyLoop
	ld [hli], a
	ld [hl], a
	add hl, bc
	dec e
	jr nz, .knockoutPartyLoop

.return
	pop hl
	pop de
	pop bc
	ret

CopyOrSwapBackupData:
	ld c, PARTY_LENGTH
	ld hl, wPartyMon1 ; assume info starts at beginning
	ld de, wSwapMon1Info
.infoLoop
	push bc
	ld bc, wSwapMon1InfoEnd - wSwapMon1Info
	call CopyOrSwapBytes
	ld bc, wPartyMon2 - wPartyMon1 - (wSwapMon1InfoEnd - wSwapMon1Info)
	add hl, bc
	pop bc
	dec c
	jr nz, .infoLoop

	ld c, PARTY_LENGTH
	ld hl, wPartyMon1PP ; assume "stats" start at PP
	ld de, wSwapMon1Stats
.statsLoop
	push bc
	ld bc, wSwapMon1StatsEnd - wSwapMon1Stats
	call CopyOrSwapBytes
	ld bc, wPartyMon2 - wPartyMon1 - (wSwapMon1StatsEnd - wSwapMon1Stats)
	add hl, bc
	pop bc
	dec c
	jr nz, .statsLoop

	ret

CopyOrSwapTeamData:
	ld bc, wPartyDataEnd - wPartyDataStart ; assume player/enemy party are same size
	ld hl, wPartyDataStart
	ld de, wEnemyPartyDataStart

CopyOrSwapBytes:
; When wSwapBytes = 1, swaps BC bytes between HL and DE
; When wSwapBytes = 0, copies from HL to DE
	ld a, [wSwapBytes]
	and a
	jr nz, .swapLoop
.copyLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .copyLoop
	ret
.swapLoop
	push bc
	ld a, [hl]
	ld b, a
	ld a, [de]
	ld [hli], a
	ld a, b
	ld [de], a
	inc de
	pop bc
	dec bc
	ld a, b
	or c
	jr nz, .swapLoop
	ret
