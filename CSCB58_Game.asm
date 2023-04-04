#####################################################################

#

# CSCB58 Winter 2023 Assembly Final Project

# University of Toronto, Scarborough

#

# Student: Yuchuan Xue, 1007626678, xueyuchu, yuchuan.xue@mail.utoronto.ca

#

# Bitmap Display Configuration:

# - Unit width in pixels: 4 

# - Unit height in pixels: 4 

# - Display width in pixels: 512 

# - Display height in pixels: 512 

# - Base Address for Display: 0x10008000 ($gp)

#

# Which milestones have been reached in this submission?

# (See the assignment handout for descriptions of the milestones)

# - Milestone 1/2/3 (choose the one the applies)
# Milestone 1, 
# Milestone 2 
# and Milestone 3
#

# Which approved features have been implemented for milestone 3?

# (See the assignment handout for the list of additional features)

# 1. Health/score

# 2. Fail Condition (Lose all HP)

# 3. Win condition (Collect the top candy to finish the level)

# 4. Moving Objects (Enemies)

# 5. Different levels (Three levels in total)

# 6. Shoot enemies (in normal condition, only left and right shot, press j to shot)

# 7. Enemy Shoot Back (The green enemy will shoot at you)

# 8.  Pickup effects (0) Coins: Collect to gain scores
#		     (1) Baskteball: Pick to become chicken, now you can press K to move up a little bit and shot in down direction
#		     (2) Ice: Pick to freeze all enemies for a while
#		     (3) HP: Pick it to restore 1 HP
#		     (4) Candy: The final destination of each level

# 9. Double Jump

# ... (add more if necessary)

#

# Link to video demonstration for final submission:

# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!

#https://utoronto-my.sharepoint.com/:v:/g/personal/yuchuan_xue_mail_utoronto_ca/EdXj7f1NbYBPsXMylqqKbkkB4dZnnBuEmqsQzIL5x0Ytqg?e=ApcG6V
#

# Are you OK with us sharing the video with people outside course staff?

# - yes / no / yes, and please share this project github link as well!
# Yes
#

# Any additional information that the TA needs to know:

# - (write here, if any)

#

#####################################################################

.eqv MS_PER_FRAME 33

.eqv AREA_BY4   65536

.eqv BASE  0x10008000
.eqv WIDTH 512
.eqv UNIT_WIDTH 4
.eqv UNIT_HEIGHT 4
.eqv ObjectWH 5 #The width and height of all players and enemies

.eqv GRAY     0xa0a0a0
.eqv WHITE    0xffffff
.eqv RED      0xff0000
.eqv GREEN    0x00ad43
.eqv BLUE     0x0000ff
.eqv ORANGE   0xff6600
.eqv YELLOW   0xffff00
.eqv EGG      0xfad6a5
.eqv ICE      0x7ed4e6
.eqv PLATFORM 0xc46200

.eqv Player_X_Bound 123
.eqv Player_Y_Bound 123
.eqv MAX_XINDEX 127

.eqv Fall_Speed     2

.eqv MAX_Enemy_By4  32
.eqv MAX_COIN_BY4   32
.eqv MAX_Shot_By4   32
.eqv MAX_PICKUP_BY4 20
.eqv MAX_ENEMYSHOT_BY4 20

.eqv Keypress_base 0xffff0000

.data
Screen: 	.space   AREA_BY4
PlayerDX: 	.word 0
PlayerDY: 	.word 0
PlayerPos: 	.word 1
PlayerType:     .word 0
PlayerStatusT:  .word 0

Score: 		.word 0
DoubleJump: 	.word 1
MaxHealth: 	.word 3
Health: 	.word 3

EnemyX: 	.word 0 88 40 0 120 84 -1 -1
EnemyY: 	.word 84 84 68 52 52 36 -1 -1
EnemyType: 	.word 1 1 2 1 2 1 0 0
EnemyPos: 	.word -1 1 -1 -1 -1 -1 -1 -1
Frozen: 	.word 0

CoinX:		.word 32 114 16 65 65 4 16 72
CoinY:		.word 100 100 82 76 64 52 38 36
CoinExist:	.word 1 1 1 1 1 1 1 1

PickupX:	.word 64 52 -1 -1 60
PickupY:	.word 96 60 -1 -1 16
PickupType:	.word 1 2 0 0 5

GotHit: 	.word 0
ShotDelay: 	.word 1
ShotX: 		.word -1 -1 -1 -1 -1 -1 -1 -1
ShotY: 		.word -1 -1 -1 -1 -1 -1 -1 -1
ShotPos: 	.word 0 0 0 0 0 0 0 0 

EnemyShotX:	.word -1 -1 -1 -1 -1 -1 -1 -1
EnemyShotY:	.word -1 -1 -1 -1 -1 -1 -1 -1
EnemyShotPos:	.word  0 0 0 0 0 0 0 0

GameOver: 	.word 1
Complete: 	.word 0
NextLevel:	.word 2
Victory:	.word 0


.text

################# Clear the Screen for Reset and Next Level#################
ClearScreen:
li $t0, BASE
li $t1, 0
ClearScreenLoop:
sw $zero, 0($t0)
addi $t0, $t0, 4
addi $t1, $t1, 4
blt $t1, 53760, ClearScreenLoop
ClearScreenEnd:
jr $ra

######################## Draw Player ######################

################# Draw Normal Egg ##################
DrawEgg:
li $t4, EGG
li $s2, PLATFORM
DrawEgg1:
lw $s1, 0($t0)
beq $s1, $s2, DrawEgg2
lw $s1, 16($t0)
beq $s1, $s2, DrawEgg2
sw $t4, 0($t0)  
sw $t4, 4($t0) 
sw $t4, 8($t0) 
sw $t4, 12($t0) 
sw $t4, 16($t0) 

DrawEgg2:
addi $t0, $t0, WIDTH
lw $s1, 0($t0)
beq $s1, $s2, DrawEgg3
lw $s1, 16($t0)
beq $s1, $s2, DrawEgg3
sw $t4, 0($t0)  
sw $t4, 4($t0) 
sw $t4, 8($t0) 
sw $t4, 12($t0) 
sw $t4, 16($t0) 

DrawEgg3:
addi $t0, $t0, WIDTH
lw $s1, 0($t0)
beq $s1, $s2, DrawEgg4
lw $s1, 16($t0)
beq $s1, $s2, DrawEgg4
sw $t4, 0($t0)  
sw $t4, 4($t0) 
sw $t4, 8($t0) 
sw $t4, 12($t0) 
sw $t4, 16($t0) 


DrawEgg4:
addi $t0, $t0, WIDTH
lw $s1, 0($t0)
beq $s1, $s2, DrawEgg5
lw $s1, 16($t0)
beq $s1, $s2, DrawEgg5
sw $t4, 0($t0)  
sw $t4, 4($t0) 
sw $t4, 8($t0) 
sw $t4, 12($t0) 
sw $t4, 16($t0) 


DrawEgg5:
addi $t0, $t0, WIDTH
lw $s1, 0($t0)
beq $s1, $s2, DrawEggEnd
lw $s1, 16($t0)
beq $s1, $s2, DrawEggEnd
sw $t4, 0($t0)  
sw $t4, 4($t0) 
sw $t4, 8($t0) 
sw $t4, 12($t0) 
sw $t4, 16($t0) 

DrawEggEnd:
jr $ra

################# Draw Failed Egg (when hp equals 0, draw Failed egg)#############
DrawFailedEgg:
li $t4, WHITE
li $t3, ORANGE
sw $t4, 0($t0)  
sw $t4, 4($t0)
sw $t4, 8($t0) 
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t3, 4($t0)
sw $t3, 8($t0)
sw $t3, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t3, 4($t0)
sw $t3, 8($t0)
sw $t3, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t3, 4($t0)
sw $t3, 8($t0)
sw $t3, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)
jr $ra


################# Draw Broken Egg  (When lose HP, become this form and be invisible for a while) ##################
DrawBrokenEgg:
li $t4, WHITE
li $s2, PLATFORM
DrawBrokenEgg1:
lw $s1, 0($t0)
beq $s1, $s2, DrawBrokenEgg2
lw $s1, 16($t0)
beq $s1, $s2, DrawBrokenEgg2
sw $t4, 0($t0)  
sw $zero, 4($t0)
sw $t4, 8($t0) 
sw $t4, 12($t0)
sw $t4, 16($t0)

DrawBrokenEgg2:
addi $t0, $t0, WIDTH
lw $s1, 0($t0)
beq $s1, $s2, DrawBrokenEgg3
lw $s1, 16($t0)
beq $s1, $s2, DrawBrokenEgg3
sw $t4, 0($t0)
sw $zero, 4($t0)
sw $zero, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

DrawBrokenEgg3:
addi $t0, $t0, WIDTH
lw $s1, 0($t0)
beq $s1, $s2, DrawBrokenEgg4
lw $s1, 16($t0)
beq $s1, $s2, DrawBrokenEgg4
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $zero, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

DrawBrokenEgg4:
addi $t0, $t0, WIDTH
lw $s1, 0($t0)
beq $s1, $s2, DrawBrokenEgg5
lw $s1, 16($t0)
beq $s1, $s2, DrawBrokenEgg5
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $zero, 8($t0)
sw $zero, 12($t0)
sw $t4, 16($t0)

DrawBrokenEgg5:
addi $t0, $t0, WIDTH
lw $s1, 0($t0)
beq $s1, $s2, DrawBrokenEggEnd
lw $s1, 16($t0)
beq $s1, $s2, DrawBrokenEggEnd
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $zero, 12($t0)
sw $t4, 16($t0)
DrawBrokenEggEnd:
jr $ra

################# Draw Chicken Form ##############
DrawChicken:
li $t4, GRAY
li $s2, PLATFORM
DrawChicken1:
lw $s1, 0($t0)
beq $s1, $s2, DrawChicken2
lw $s1, 16($t0)
beq $s1, $s2, DrawChicken2
sw $t4, 0($t0)  
sw $t4, 4($t0) 
sw $t4, 8($t0) 
sw $t4, 12($t0) 
sw $t4, 16($t0) 

DrawChicken2:
addi $t0, $t0, WIDTH
li $t4, YELLOW
lw $s1, 0($t0)
beq $s1, $s2, DrawChicken3
lw $s1, 16($t0)
beq $s1, $s2, DrawChicken3
sw $t4, 0($t0)  
sw $zero, 4($t0) 
sw $t4, 8($t0) 
sw $zero, 12($t0) 
sw $t4, 16($t0) 

DrawChicken3:
addi $t0, $t0, WIDTH
lw $s1, 0($t0)
beq $s1, $s2, DrawChicken4
lw $s1, 16($t0)
beq $s1, $s2, DrawChicken4
sw $t4, 0($t0)  
sw $t4, 4($t0) 
sw $t4, 8($t0) 
sw $t4, 12($t0) 
sw $t4, 16($t0) 


DrawChicken4:
addi $t0, $t0, WIDTH
lw $s1, 0($t0)
beq $s1, $s2, DrawChicken5
lw $s1, 16($t0)
beq $s1, $s2, DrawChicken5
sw $t4, 0($t0)  
sw $t4, 4($t0) 
li $t4, ORANGE
sw $t4, 8($t0) 
li $t4, YELLOW
sw $t4, 12($t0) 
sw $t4, 16($t0) 


DrawChicken5:
addi $t0, $t0, WIDTH
lw $s1, 0($t0)
beq $s1, $s2, DrawChickenEnd
lw $s1, 16($t0)
beq $s1, $s2, DrawChickenEnd
sw $t4, 0($t0)  
sw $t4, 4($t0) 
sw $t4, 8($t0) 
sw $t4, 12($t0) 
sw $t4, 16($t0) 

DrawChickenEnd:
jr $ra

#########################  Coin Part #########################3

################# DRAW Coin ######################
DrawCoin:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

#2*2 coin
li $t2, YELLOW
sw $t2, 0($t0)
sw $t2, 4($t0)
addi $t0, $t0, WIDTH
sw $t2, 0($t0)
sw $t2, 4($t0)
jr $ra

############### Clear Coin #####################
ClearCoin:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

#2*2 coin
sw $zero, 0($t0)
sw $zero, 4($t0)
addi $t0, $t0, WIDTH
sw $zero, 0($t0)
sw $zero, 4($t0)
jr $ra

################# Draw All Coin ##################
DrawAllCoin:
	li $t5, MAX_COIN_BY4
	li $a1, 0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
DrawAllCoinLoop:
	beq $a1, $t5, DrawAllCoinEnd
	lw $t1, CoinExist($a1)
	beqz $t1, DrawAllCoinLoopUpdate
	#Draw the coin
	lw $t0, CoinX($a1)
	lw $t1, CoinY($a1)
	jal DrawCoin
DrawAllCoinLoopUpdate:
	addi $a1, $a1, 4
	j DrawAllCoinLoop
DrawAllCoinEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
############## Check Player-Coin Collision #######
CheckCoin:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t3, 0
CheckCoinLoop:
	lw $t1, CoinExist($t3)
	beqz $t1, CheckCoinLoopUpdate # If the coin is collected, don't check
	lw $t0, CoinX($t3)
	lw $t1, CoinY($t3)
	addi $t4, $t8, ObjectWH
	addi $t5, $t9, ObjectWH
	bge $t0, $t4, CheckCoinLoopUpdate
	bge $t1, $t5, CheckCoinLoopUpdate
	addi $t0, $t0, 2
	addi $t1, $t1, 2
	ble $t0, $t8, CheckCoinLoopUpdate
	ble $t1, $t9, CheckCoinLoopUpdate
CheckCoinYes:
	#If they collide, collect coin and gain score
	addi $t0, $t0, -2
	addi $t1, $t1, -2
	jal ClearCoin
	li $t1, 0
	sw $t1, CoinExist($t3)
	lw $t1, Score
	addi $t1, $t1, 100
	sw $t1, Score
CheckCoinLoopUpdate:
	addi $t3, $t3, 4
	bne $t3, MAX_COIN_BY4, CheckCoinLoop
CheckCoinEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
######################## Pickup Parts #######################################3

################# Draw pickups #################### (Pickups are all 3 * 3)

###### Pickup 1: Basketball (pick it to become chicken)
DrawBasketball:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t2, ORANGE
li $t3, GRAY
sw $t2, 0($t0)
sw $t3, 4($t0)
sw $t2, 8($t0)
addi $t0, $t0, WIDTH
sw $t3, 0($t0)
sw $t3, 4($t0)
sw $t3, 8($t0)
addi $t0, $t0, WIDTH
sw $t2, 0($t0)
sw $t3, 4($t0)
sw $t2, 8($t0)
jr $ra

####### Pickup 2: Ice  (pick it to freeze all enemy)
DrawIce: 
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t2, ICE
li $t3, WHITE
sw $t3, 0($t0)
sw $t2, 4($t0)
sw $t2, 8($t0)
addi $t0, $t0, WIDTH
sw $t2, 0($t0)
sw $t3, 4($t0)
sw $t2, 8($t0)
addi $t0, $t0, WIDTH
sw $t2, 0($t0)
sw $t2, 4($t0)
sw $t3, 8($t0)
jr $ra

################## Pickup 3: Health #################
# Restore Health
DrawPickupHp:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t2, RED
sw $zero, 0($t0)
sw $t2, 4($t0)
sw $zero, 8($t0)
addi $t0, $t0, WIDTH
sw $t2, 0($t0)
sw $t2, 4($t0)
sw $t2, 8($t0)
addi $t0, $t0, WIDTH
sw $zero, 0($t0)
sw $t2, 4($t0)
sw $zero, 8($t0)
jr $ra

################## Final Pickup: Special Candy ######
# Pick it to enter next level
DrawDestination:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t2, ORANGE
sw $t2, 0($t0)
li $t2, GRAY
sw $t2, 4($t0)
li $t2, BLUE
sw $t2, 8($t0)


addi $t0, $t0, WIDTH
li $t2, RED
sw $t2, 0($t0)
li $t2, WHITE
sw $t2, 4($t0)
li $t2, GREEN
sw $t2, 8($t0)

addi $t0, $t0, WIDTH
li $t2, ICE
sw $t2, 0($t0)
li $t2, ORANGE
sw $t2, 4($t0)
li $t2, EGG
sw $t2, 8($t0)
jr $ra

################ Clear Pickups (Except the final Large Basketball) ###################
ClearPickup:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

sw $zero, 0($t0)
sw $zero, 4($t0)
sw $zero, 8($t0)
addi $t0, $t0, WIDTH
sw $zero, 0($t0)
sw $zero, 4($t0)
sw $zero, 8($t0)
addi $t0, $t0, WIDTH
sw $zero, 0($t0)
sw $zero, 4($t0)
sw $zero, 8($t0)
jr $ra

################ Draw All Pickups #################
DrawAllPickup:
	li $t5, MAX_PICKUP_BY4
	li $a1, 0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
DrawAllPickupLoop:
	beq $a1, $t5, DrawAllPickupEnd
	lw $t2, PickupType($a1)
	beqz $t2, DrawAllPickupLoopUpdate
	lw $t0, PickupX($a1)
	lw $t1, PickupY($a1)
	beq $t2, 2, DrawPickupIce
	beq $t2, 3, DrawPickupHealth
	beq $t2, 5, DrawFinalDestination
DrawPickupBasketball:
	jal DrawBasketball
	j DrawAllPickupLoopUpdate
DrawPickupIce:
	jal DrawIce
	j DrawAllPickupLoopUpdate
DrawPickupHealth:
	jal DrawPickupHp
	j DrawAllPickupLoopUpdate
DrawFinalDestination:
	jal DrawDestination
	j DrawAllPickupLoopUpdate
DrawAllPickupLoopUpdate:
	addi $a1, $a1, 4
	j DrawAllPickupLoop
DrawAllPickupEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
################# Check Pickup-Player Collision ###############
CheckPickup:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t3, 0
CheckPickupLoop:
	lw $t1, PickupType($t3)
	beqz $t1, CheckPickupLoopUpdate # If the coin is collected, don't check
	lw $t0, PickupX($t3)
	lw $t1, PickupY($t3)
	addi $t4, $t8, ObjectWH
	addi $t5, $t9, ObjectWH
	bge $t0, $t4, CheckPickupLoopUpdate
	bge $t1, $t5, CheckPickupLoopUpdate
	addi $t0, $t0, 3
	addi $t1, $t1, 3
	ble $t0, $t8, CheckPickupLoopUpdate
	ble $t1, $t9, CheckPickupLoopUpdate
CheckPickupYes:
	#If they collide, collect coin and gain score
	addi $t0, $t0, -3
	addi $t1, $t1, -3
	jal ClearPickup
	lw $t1, PickupType($t3)
	beq $t1, 2, PickIce
	beq $t1, 3, PickHealth
	beq $t1, 5, PickFinalDestination
PickBasketBall:
	li $t1, 1
	sw $t1, PlayerType
	li $t1, 120
	sw $t1, PlayerStatusT
	j RemovePickup
PickIce:
	li $t1, 200
	sw $t1, Frozen
	j RemovePickup
PickHealth:
	lw $t1, Health
	beq $t1, 3, RemovePickup #If Hp if full, don't restore
	addi $t1, $t1, 1
	sw $t1, Health
	j RemovePickup
PickFinalDestination:
	li $t1, 1
	sw $t1, Complete
	lw $t1, Score
	addi $t1, $t1, 1900
	sw $t1, Score
	j RemovePickup
RemovePickup:
	li $t1, 0
	sw $t1, PickupType($t3)
	lw $t1, Score
	addi $t1, $t1, 100
	sw $t1, Score
CheckPickupLoopUpdate:
	addi $t3, $t3, 4
	bne $t3, MAX_PICKUP_BY4, CheckPickupLoop
CheckPickupEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

############### Check Special Status Time ###########################
CheckStatusTime:
	lw $t1, PlayerStatusT
	beqz $t1, CheckStatusIce ##### When player don't have special status, ignore it
	addi $t1, $t1, -1
	bnez $t1, LoadPlayerStatusTime
PlayerStatusFinish:
	# When status time finish, become normal egg
	sw $zero, PlayerType
LoadPlayerStatusTime:
	sw $t1, PlayerStatusT
CheckStatusIce:
	lw $t1, Frozen
	beqz $t1, CheckStatusEnd
	addi $t1, $t1, -1
	sw $t1, Frozen
CheckStatusEnd:
	jr $ra

############################# Enemy Part ######################################

################# DRAW ENEMY One #################
# Enemy One Moving Left
DrawEnemyOneL:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t4, RED
li $t2, YELLOW
sw $t4, 0($t0)  
sw $t4, 4($t0)
sw $t4, 8($t0) 
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t2, 0($t0)
sw $t4, 4($t0)
sw $t2, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)


addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)
jr $ra

# Enemy One Moving Right
DrawEnemyOneR:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t4, RED
li $t2, YELLOW
sw $t4, 0($t0)  
sw $t4, 4($t0)
sw $t4, 8($t0) 
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t2, 8($t0)
sw $t4, 12($t0)
sw $t2, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)


addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)
jr $ra

################# Draw Enemy Two ##################
######## Enemy two are Green Enemy that can shot player
# Enemy Two Moving Left
DrawEnemyTwoL:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t4, GREEN
sw $t4, 0($t0)  
sw $t4, 4($t0)
sw $t4, 8($t0) 
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $zero, 0($t0)
sw $t4, 4($t0)
sw $zero, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $zero, 0($t0)
sw $zero, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)


addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)
jr $ra

# Enemy Two Moving Right
DrawEnemyTwoR:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t4, GREEN
sw $t4, 0($t0)  
sw $t4, 4($t0)
sw $t4, 8($t0) 
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $zero, 8($t0)
sw $t4, 12($t0)
sw $zero, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $zero, 12($t0)
sw $zero, 16($t0)


addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)
jr $ra

################# Draw Enemy Three ################
#Enemy Three wears armor and need three shot to kill (2 shot for armor and one shot
# for itself). Collide with it that wears armor will reduce two HP. Without armor, it is enemy one
# Enemy Three Moving Left
DrawEnemyThreeL:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t4, GRAY
li $t2, YELLOW
sw $t4, 0($t0)  
sw $t4, 4($t0)
sw $t4, 8($t0) 
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t2, 0($t0)
sw $t4, 4($t0)
sw $t2, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)


addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)
jr $ra

# Enemy Three Moving Right
DrawEnemyThreeR:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t4, GRAY
li $t2, YELLOW
sw $t4, 0($t0)  
sw $t4, 4($t0)
sw $t4, 8($t0) 
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t2, 8($t0)
sw $t4, 12($t0)
sw $t2, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)


addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)
jr $ra

# Enemy Three with Broken Armor Moving Left
DrawEnemyThreeBrokenL:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t4, GRAY
li $t2, YELLOW
li $s3, RED
sw $t4, 0($t0)  
sw $t4, 4($t0)
sw $t4, 8($t0) 
sw $s3, 12($t0)
sw $s3, 16($t0)

addi $t0, $t0, WIDTH
sw $t2, 0($t0)
sw $t4, 4($t0)
sw $t2, 8($t0)
sw $s3, 12($t0)
sw $s3, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $s3, 16($t0)


addi $t0, $t0, WIDTH
sw $s3, 0($t0)
sw $s3, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $s3, 16($t0)
jr $ra

# Enemy Three with Broken Armor Moving Right
DrawEnemyThreeBrokenR:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t4, GRAY
li $t2, YELLOW
li $s3, RED
sw $s3, 0($t0)  
sw $s3, 4($t0)
sw $t4, 8($t0) 
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $s3, 0($t0)
sw $s3, 4($t0)
sw $t2, 8($t0)
sw $t4, 12($t0)
sw $t2, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $s3, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)


addi $t0, $t0, WIDTH
sw $s3, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $s3, 12($t0)
sw $s3, 16($t0)
jr $ra

################# Draw Frozen Enemy ###############
DrawFrozen:
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0

li $t4, ICE
li $t2, WHITE
sw $t4, 0($t0)  
sw $t4, 4($t0)
sw $t4, 8($t0) 
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t2, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t2, 12($t0)
sw $t4, 16($t0)

addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)


addi $t0, $t0, WIDTH
sw $t4, 0($t0)
sw $t4, 4($t0)
sw $t4, 8($t0)
sw $t4, 12($t0)
sw $t4, 16($t0)
jr $ra

################# DRAW ALL ENEMY  #################
DrawEnemy:
	li $t5, MAX_Enemy_By4
	li $a1, 0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
DrawEnemyLoop:
	beq $a1, $t5, Draw_Enemy_End
	lw $t1, EnemyType($a1)
	beqz $t1, DrawEnemyLoopUpdate
	lw $t1, Frozen
	bnez $t1, DrawFrozenEnemy
	lw $t1, EnemyType($a1)
	beq $t1, 2, DrawEnemyTwoLeft
	beq $t1, 3, DrawEnemyThreeLeft
	beq $t1, 4, DrawEnemyThreeBrokenLeft
DrawEnemyOneLeft:
	lw $t2, EnemyPos($a1)
	lw $t0, EnemyX($a1)
	lw $t1, EnemyY($a1)
	beq $t2, 1 DrawEnemyOneRight
	jal DrawEnemyOneL
	j DrawEnemyLoopUpdate
DrawEnemyOneRight:
	jal DrawEnemyOneR
	j DrawEnemyLoopUpdate
DrawEnemyTwoLeft:
	lw $t2, EnemyPos($a1)
	lw $t0, EnemyX($a1)
	lw $t1, EnemyY($a1)
	beq $t2, 1 DrawEnemyTwoRight
	jal DrawEnemyTwoL
	j DrawEnemyLoopUpdate
DrawEnemyTwoRight:
	jal DrawEnemyTwoR
	j DrawEnemyLoopUpdate
DrawEnemyThreeLeft:
	lw $t2, EnemyPos($a1)
	lw $t0, EnemyX($a1)
	lw $t1, EnemyY($a1)
	beq $t2, 1 DrawEnemyThreeRight
	jal DrawEnemyThreeL
	j DrawEnemyLoopUpdate
DrawEnemyThreeRight:
	jal DrawEnemyThreeR
	j DrawEnemyLoopUpdate
DrawEnemyThreeBrokenLeft:
	lw $t2, EnemyPos($a1)
	lw $t0, EnemyX($a1)
	lw $t1, EnemyY($a1)
	beq $t2, 1 DrawEnemyThreeBrokenRight
	jal DrawEnemyThreeBrokenL
	j DrawEnemyLoopUpdate
DrawEnemyThreeBrokenRight:
	jal DrawEnemyThreeBrokenR
	j DrawEnemyLoopUpdate
DrawFrozenEnemy:
	lw $t0, EnemyX($a1)
	lw $t1, EnemyY($a1)
	jal DrawFrozen
	j DrawEnemyLoopUpdate
DrawEnemyLoopUpdate:
	addi $a1, $a1, 4
	j DrawEnemyLoop
Draw_Enemy_End:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

############# Check whether Enemy reach edge of Platform ######
CheckEnemyEdge:
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	
	addi $t3, $zero, WIDTH
	mult $t1, $t3
	mflo $t1
	addi $t3, $zero, UNIT_WIDTH
	mult $t0, $t3
	mflo $t0
	add $t0, $t1, $t0
	add $t0, $t0, $s0
	beq $t2, 1, CheckEnemyRightEdge
CheckEnemyLeftEdge:
	addi $t0, $t0, 2556
	lw $t1, 0($t0)
	beq $t1, $zero, CheckEnemyEdgeReverse
	addi $t3, $zero, 0
	j CheckEnemyEdgeEnd
CheckEnemyRightEdge:
	addi $t0, $t0, 2580
	lw $t1, 0($t0)
	beq $t1, $zero, CheckEnemyEdgeReverse
	addi $t3, $zero, 0
	j CheckEnemyEdgeEnd
CheckEnemyEdgeReverse:
	addi $t3, $zero, 1
CheckEnemyEdgeEnd:
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
############# Clear Enemy ####################
ClearEnemy:
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	
	addi $t3, $zero, WIDTH
	mult $t1, $t3
	mflo $t1
	addi $t3, $zero, UNIT_WIDTH
	mult $t0, $t3
	mflo $t0
	add $t0, $t1, $t0
	add $t0, $t0, $s0

	sw $zero, 0($t0)  
	sw $zero, 4($t0) 
	sw $zero, 8($t0) 
	sw $zero, 12($t0)
	sw $zero, 16($t0)
	
	addi $t0, $t0, WIDTH
	sw $zero, 0($t0)
	sw $zero, 4($t0)
	sw $zero, 8($t0)
	sw $zero, 12($t0)
	sw $zero, 16($t0)

	addi $t0, $t0, WIDTH
	sw $zero, 0($t0)
	sw $zero, 4($t0)
	sw $zero, 8($t0)
	sw $zero, 12($t0)
	sw $zero, 16($t0)

	addi $t0, $t0, WIDTH
	sw $zero, 0($t0)
	sw $zero, 4($t0)
	sw $zero, 8($t0)
	sw $zero, 12($t0)
	sw $zero, 16($t0)

	addi $t0, $t0, WIDTH
	sw $zero, 0($t0)
	sw $zero, 4($t0)
	sw $zero, 8($t0)
	sw $zero, 12($t0)
	sw $zero, 16($t0)

	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

############## Update All Enemy Position #####
UpdateEnemy:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	bnez $s5, UpdateEnemyEnd
	li $t5, MAX_Enemy_By4
	li $a1, 0
UpdateEnemyLoop:
	beq $a1, $t5, UpdateEnemyEnd
	lw $t0, EnemyType($a1)
	beqz $t0, UpdateEnemyLoopUpdate
	lw $t2, Frozen
	bnez $t2, UpdateEnemyLoopUpdate
	lw $t0, EnemyX($a1)
	lw $t1, EnemyY($a1)
	lw $t2, EnemyPos($a1)
	beq $t2, 1, UpdateEnemyRight
UpdateEnemyLeft:
	beqz $t0, UpdateEnemyReverse	#Check Whether it reaches the end of screen
	jal CheckEnemyEdge		#Check whether it reaches the edge of platform
	beq $t3, 1, UpdateEnemyReverse
	jal ClearEnemy
	addi $t0, $t0, -1
	sw $t0, EnemyX($a1)
	j UpdateEnemyLoopUpdate
UpdateEnemyRight:
	beq $t0, 123, UpdateEnemyReverse	#Check Whether it reaches the end of screen
	jal CheckEnemyEdge		#Check whether it reaches the edge of platform
	beq $t3, 1, UpdateEnemyReverse
	jal ClearEnemy
	addi $t0, $t0, 1
	sw $t0, EnemyX($a1)
	j UpdateEnemyLoopUpdate
UpdateEnemyReverse:
	sub $t2, $zero, $t2
	sw $t2, EnemyPos($a1)
	j UpdateEnemyLoopUpdate
UpdateEnemyLoopUpdate:
	addi $a1, $a1, 4
	j UpdateEnemyLoop
UpdateEnemyEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


################# Check Enemy-Player Collision ###########
CheckEnemyCollision:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t2, 0
CheckEnemyCollisionLoop:
	lw $t1, EnemyType($t2)
	beq $t1, 0, CheckEnemyCollisionLoopUpdate # If the enemy is dead or does not exist, don't check
	lw $t0, EnemyX($t2)
	lw $t1, EnemyY($t2)
	addi $t3, $t8, ObjectWH
	addi $t4, $t9, ObjectWH
	bge $t0, $t3, CheckEnemyCollisionLoopUpdate
	bge $t1, $t4, CheckEnemyCollisionLoopUpdate
	addi $t0, $t0, ObjectWH
	addi $t1, $t1, ObjectWH
	ble $t0, $t8, CheckEnemyCollisionLoopUpdate
	ble $t1, $t9, CheckEnemyCollisionLoopUpdate
CheckEnemyCollisionYes:
	#If they collide, deal damage to player and kill enemy (But if enemy is frozen, player HP does not fall)
	addi $t0, $t0, -5
	addi $t1, $t1, -5
	jal ClearEnemy
	lw $t3, EnemyType($t2)
	li $t1, 0
	sw $t1, EnemyType($t2)
	lw $t1, Frozen
	bnez $t1, CheckEnemyCollisionFrozen
	lw $t1, GotHit
	bnez $t1, CheckEnemyCollisionLoopUpdate #If being hit for more than one time in a short time, immune
	addi $t1, $zero, 30
	sw $t1, GotHit
	lw $t1, Health
	bge $t3, 3, MoreDamage
	addi $t1, $t1, -1
	sw $t1, Health
	j CheckEnemyCollisionScore
MoreDamage:
	ble $t1, 2, SetToZero
	addi $t1, $t1, -2
	sw $t1, Health
	j CheckEnemyCollisionScore
SetToZero:
	sw $zero, Health
CheckEnemyCollisionScore:
	lw $t1, Score
	addi $t1, $t1, 50
	sw $t1, Score
	j CheckEnemyCollisionLoopUpdate
CheckEnemyCollisionFrozen:
	lw $t1, Score
	addi $t1, $t1, 200
	sw $t1, Score
CheckEnemyCollisionLoopUpdate:
	addi $t2, $t2, 4
	bne $t2, 32, CheckEnemyCollisionLoop
CheckEnemyCollisionEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
###################### Shot from Enemy #######################3

################# Check Whether Enemy Will Shot #########
CheckEnemyShot:
	li $t0, 0
	lw $t1, Frozen
	bnez $t1, CheckEnemyShotEnd  # If Enemies are frozen, ignore the enemy shot
CheckEnemyShotLoop:
	lw $t1, EnemyType($t0)
	bne $t1, 2, CheckEnemyShotLoopUpdate
CheckEnemyShotY:
	lw $t2, EnemyY($t0)
	addi $t2, $t2, 2
	addi $t3, $t9, 4
	blt $t2, $t9, CheckEnemyShotLoopUpdate
	bgt $t2, $t3, CheckEnemyShotLoopUpdate
	lw $t1, EnemyPos($t0)
	bltz $t1, CheckEnemyShotLeft
CheckEnemyShotRight:
	lw $t1, EnemyX($t0)
	bgt $t1, $t8, CheckEnemyShotLoopUpdate
	lw $t3, EnemyShotX($t0)
	bgez $t3, CheckEnemyShotLoopUpdate
	addi $t1, $t1, 5
	sw $t1, EnemyShotX($t0)
	sw $t2, EnemyShotY($t0)
	li $t3, 1
	sw $t3, EnemyShotPos($t0)
	j CheckEnemyShotLoopUpdate
CheckEnemyShotLeft:
	lw $t1, EnemyX($t0)
	blt $t1, $t8, CheckEnemyShotLoopUpdate
	lw $t3, EnemyShotX($t0)
	bgez $t3, CheckEnemyShotLoopUpdate
	addi $t1, $t1, -1
	li $t3, -1
	sw $t1, EnemyShotX($t0)
	sw $t2, EnemyShotY($t0)
	sw $t3, EnemyShotPos($t0)
CheckEnemyShotLoopUpdate:
	addi $t0, $t0, 4
	blt $t0, MAX_ENEMYSHOT_BY4, CheckEnemyShotLoop
CheckEnemyShotEnd:
	jr $ra
	
####################### Draw Enemy Shot ##################
DrawEnemyShot:
	li $t0, 0
	li $t1, GREEN
DrawEnemyShotLoop:
	lw $t2, EnemyShotX($t0)
	lw $t3, EnemyShotY($t0)
	lw $t4, EnemyShotPos($t0)
	bltz $t2, DrawEnemyShotLoopUpdate
	bltz $t4,DrawEnemyShotLeft
DrawEnemyShotRight:
	addi $t2, $t2, 1
	sw $t2, EnemyShotX($t0)
	add $t5, $t2, $zero
	addi $t4, $zero, WIDTH
	mult $t3, $t4
	mflo $t3
	addi $t4, $zero, UNIT_WIDTH
	mult $t2, $t4
	mflo $t2
	add $t2, $t2, $t3
	add $t2, $t2, $s0
	bgt $t5, MAX_XINDEX, ClearEnemyShotRight
	sw $zero, -4($t2) 
	sw $t1, 0($t2) 
	j DrawEnemyShotLoopUpdate
ClearEnemyShotRight:
	sw $zero, -4($t2) 
	sw $zero, 0($t2) 
	li $t2, -1
	sw $t2, EnemyShotX($t0)
	sw $t2, EnemyShotY($t0)
	sw $zero, EnemyShotPos($t0)
	j DrawEnemyShotLoopUpdate
DrawEnemyShotLeft:
	addi $t2, $t2, -1
	sw $t2, EnemyShotX($t0)
	add $t5, $t2, $zero
	addi $t4, $zero, WIDTH
	mult $t3, $t4
	mflo $t3
	addi $t4, $zero, UNIT_WIDTH
	mult $t2, $t4
	mflo $t2
	add $t2, $t2, $t3
	add $t2, $t2, $s0
	bltz $t5, ClearEnemyShotLeft
	sw $zero, 4($t2) 
	sw $t1, 0($t2) 
	j DrawEnemyShotLoopUpdate
ClearEnemyShotLeft:
	sw $zero, 4($t2) 
	sw $zero, 0($t2) 
	li $t2, -1
	sw $t2, EnemyShotX($t0)
	sw $t2, EnemyShotY($t0)
	sw $zero, EnemyShotPos($t0)
	j DrawEnemyShotLoopUpdate
DrawEnemyShotLoopUpdate:
	addi $t0, $t0, 4
	blt $t0, MAX_ENEMYSHOT_BY4, DrawEnemyShotLoop
DrawEnemyShotEnd:
	jr $ra
	

################# Check Enemy Shot Hit Player ###########
CheckHitPlayer:
	li $t3, 0
CheckHitPlayerLoop:
	lw $t4, EnemyShotX($t3)
	lw $t5, EnemyShotY($t3)
	bltz $t4, CheckHitPlayerLoopUpdate

	addi $t0 $t8, 0
	addi $t1, $t9, 0
	blt $t4, $t0, CheckHitPlayerLoopUpdate
	blt $t5, $t1, CheckHitPlayerLoopUpdate
	addi $t0, $t0, 4
	addi $t1, $t1, 4
	bgt $t4, $t0, CheckHitPlayerLoopUpdate
	bgt $t5, $t1, CheckHitPlayerLoopUpdate

	# Deal Damage to Player if GotHit Equals 0
	lw $t0, GotHit
	bnez $t0, CheckHitPlayerClearShot
	lw $t0, Health
	addi $t0, $t0, -1
	sw $t0, Health
	li $t0, 30
	sw $t0, GotHit
	
CheckHitPlayerClearShot:
	li $t1, BASE
	addi $t0, $zero, WIDTH
	mult $t5, $t0
	mflo $t5
	addi $t0, $zero, UNIT_WIDTH
	mult $t4, $t0
	mflo $t4
	add $t4, $t4, $t5
	add $t4, $t4, $t1
	sw $zero, -4($t4)
	sw $zero, 0($t4) 
	sw $zero, 4($t4)
	li $t4, -1
	sw $t4, EnemyShotX($t3)
	sw $t4, EnemyShotY($t3)
	sw $zero, EnemyShotPos($t3)
	j CheckHitPlayerLoopUpdate
	
CheckHitPlayerLoopUpdate:
	addi $t3, $t3, 4
	blt $t3, MAX_ENEMYSHOT_BY4, CheckHitPlayerLoop
CheckHitPlayerEnd:
	jr $ra
	

###################### Another Player Part ###########

################# DRAW PLAYER ################
Drawplayer:
	add $t0, $t8, $zero
	add $t1, $t9, $zero
	addi $t2, $zero, WIDTH
	mult $t1, $t2
	mflo $t1
	addi $t2, $zero, UNIT_WIDTH
	mult $t0, $t2
	mflo $t0
	add $t0, $t1, $t0
	add $t0, $t0, $s0

	addi $sp, $sp, -4
	sw $ra, 0($sp)
	lw $t1, Health
	beqz $t1, FailedEgg
	lw $t1, GotHit
	bnez $t1, HurtEgg
	lw $t1, PlayerType
	beq $t1, 1, ChickenEgg
NormalEgg:
	jal DrawEgg
	j DrawPlayerEnd
ChickenEgg:
	jal DrawChicken
	j DrawPlayerEnd
HurtEgg:
	addi $t1, $t1, -1
	sw $t1, GotHit
	jal DrawBrokenEgg
	j DrawPlayerEnd
FailedEgg:
	jal DrawFailedEgg
DrawPlayerEnd:	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

################### Clear Player #####################
ClearPlayer:
add $t0, $t8, $zero
add $t1, $t9, $zero
addi $t2, $zero, WIDTH
mult $t1, $t2
mflo $t1
addi $t2, $zero, UNIT_WIDTH
mult $t0, $t2
mflo $t0
add $t0, $t1, $t0
add $t0, $t0, $s0
ClearP1:
li $t2, PLATFORM
lw $t1, 0($t0)
beq $t1, $t2, ClearP2
lw $t1, 16($t0)
beq $t1, $t2, ClearP2
sw $zero, 0($t0)  
sw $zero, 4($t0) 
sw $zero, 8($t0) 
sw $zero, 12($t0)
sw $zero, 16($t0)

ClearP2:
addi $t0, $t0, WIDTH
lw $t1, 0($t0)
beq $t1, $t2, ClearP3
lw $t1, 16($t0)
beq $t1, $t2, ClearP3
sw $zero, 0($t0)
sw $zero, 4($t0)
sw $zero, 8($t0)
sw $zero, 12($t0)
sw $zero, 16($t0)

ClearP3:
addi $t0, $t0, WIDTH
lw $t1, 0($t0)
beq $t1, $t2, ClearP4
lw $t1, 16($t0)
beq $t1, $t2, ClearP4
sw $zero, 0($t0)
sw $zero, 4($t0)
sw $zero, 8($t0)
sw $zero, 12($t0)
sw $zero, 16($t0)

ClearP4:
addi $t0, $t0, WIDTH
lw $t1, 0($t0)
beq $t1, $t2, ClearP5
lw $t1, 16($t0)
beq $t1, $t2, ClearP5
sw $zero, 0($t0)
sw $zero, 4($t0)
sw $zero, 8($t0)
sw $zero, 12($t0)
sw $zero, 16($t0)

ClearP5:
addi $t0, $t0, WIDTH
lw $t1, 0($t0)
beq $t1, $t2, ClearPEnd
lw $t1, 16($t0)
beq $t1, $t2, ClearPEnd
sw $zero, 0($t0)
sw $zero, 4($t0)
sw $zero, 8($t0)
sw $zero, 12($t0)
sw $zero, 16($t0)
ClearPEnd:
jr $ra


#################### Platforms for Game #####################################

################### Draw Base Platform ###################
DrawBase:
addi $t2, $zero, PLATFORM
li $t0, BASE
addi $t0, $t0, 53760
li $t1, 1024
li $t3, 0
Baseloop:
beq $t3, $t1, BaseEnd
sw $t2, 0($t0)
addi $t0, $t0, 4
addi $t3, $t3, 4
j Baseloop
BaseEnd:
jr $ra

################# Draw Platform (Length: 30) #############
DrawPlatform30:
addi $sp, $sp, -4
sw $t0, 0($sp)
li $t2, PLATFORM
li $t1, 120
li $t3, 0
DrawPlatform30Loop:
beq $t3, $t1, DrawPlatform30End
sw $t2, 0($t0)
addi $t3, $t3, 4
addi $t0, $t0, 4
j DrawPlatform30Loop
DrawPlatform30End:
lw $t0, 0($sp)
addi $sp, $sp, 4
jr $ra


################# Draw Platform (Length: 40) #############
DrawPlatform40:
addi $sp, $sp, -4
sw $t0, 0($sp)
li $t2, PLATFORM
li $t1, 160
li $t3, 0
DrawPlatform40Loop:
beq $t3, $t1, DrawPlatform40End
sw $t2, 0($t0)
addi $t3, $t3, 4
addi $t0, $t0, 4
j DrawPlatform40Loop
DrawPlatform40End:
lw $t0, 0($sp)
addi $sp, $sp, 4
jr $ra

################# Draw Platform Level One #################
DrawPlatformLevelOne:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t2, PLATFORM
	li $t0, BASE
	addi $t0, $t0, 53760

	addi $t0, $t0, -8192
	jal DrawPlatform40
	addi $t0, $t0, 352
	jal DrawPlatform40
	addi $t0, $t0, -352

	addi $t0, $t0, -8192
	addi $t0, $t0, 96
	jal DrawPlatform40
	addi $t0, $t0, 160
	jal DrawPlatform40
	addi $t0, $t0, -256

	addi $t0, $t0, -8192
	jal DrawPlatform30
	addi $t0, $t0, 196
	jal DrawPlatform30
	addi $t0, $t0, 196
	jal DrawPlatform30
	addi $t0, $t0, -392

	addi $t0, $t0, -8192
	addi $t0, $t0, 60
	jal DrawPlatform40
	addi $t0, $t0, 232
	jal DrawPlatform40
	addi $t0, $t0, -292

	addi $t0, $t0, -8192
	addi $t0, $t0, 176
	jal DrawPlatform40

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

################ Draw Platform Level Two ##################
DrawPlatformLevelTwo:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t2, PLATFORM
	li $t0, BASE
	addi $t0, $t0, 53760

	addi $t0, $t0, -8192
	addi $t0, $t0, 192
	jal DrawPlatform40
	addi $t0, $t0, 160
	jal DrawPlatform40
	addi $t0, $t0, -352

	addi $t0, $t0, -8192
	addi $t0, $t0, 196
	jal DrawPlatform30
	addi $t0, $t0, -196

	addi $t0, $t0, -8192
	jal DrawPlatform40
	addi $t0, $t0, 160
	jal DrawPlatform40
	addi $t0, $t0, -160

	addi $t0, $t0, -8192
	addi $t0, $t0, 60
	jal DrawPlatform40
	addi $t0, $t0, 232
	jal DrawPlatform40
	addi $t0, $t0, -292

	addi $t0, $t0, -8192
	addi $t0, $t0, 352
	jal DrawPlatform40

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

############## Draw Platform Level Three
DrawPlatformLevelThree:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t2, PLATFORM
	li $t0, BASE
	addi $t0, $t0, 53760

	addi $t0, $t0, -8192
	addi $t0, $t0, 56
	jal DrawPlatform30
	addi $t0, $t0, 120
	jal DrawPlatform40
	addi $t0, $t0, 160
	jal DrawPlatform30
	addi $t0, $t0, -356

	addi $t0, $t0, -8192
	addi $t0, $t0, 96
	jal DrawPlatform40
	addi $t0, $t0, 160
	jal DrawPlatform40
	addi $t0, $t0, -256

	addi $t0, $t0, -8192
	addi $t0, $t0, 136
	jal DrawPlatform30
	addi $t0, $t0, 120
	jal DrawPlatform30
	addi $t0, $t0, -256

	addi $t0, $t0, -8192
	addi $t0, $t0, 176
	jal DrawPlatform40
	addi $t0, $t0, -176

	addi $t0, $t0, -8192
	addi $t0, $t0, 196
	jal DrawPlatform30

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
##################### Draw HP and Scores ###########

################ Draw Number ###########
DrawNum:
	li $t4, WHITE
	move $a1, $t0
	
	## Clear the Original Number
	sw $zero, 0($t0)
	sw $zero, 4($t0)
	sw $zero, 8($t0)
	addi $t0, $t0, 512
	sw $zero, 0($t0)
	sw $zero, 8($t0)
	addi $t0, $t0, 512
	sw $zero, 0($t0)
	sw $zero, 4($t0)
	sw $zero, 8($t0)
	addi $t0, $t0, 512
	sw $zero, 0($t0)
	sw $zero, 8($t0)
	addi $t0, $t0, 512
	sw $zero, 0($t0)
	sw $zero, 4($t0)
	sw $zero, 8($t0)
	
	move $t0, $a1
	beq $t3, 1, DrawOne
	beq $t3, 2, DrawTwo
	beq $t3, 3, DrawThree
	beq $t3, 4, DrawFour
	beq $t3, 5, DrawFive
	beq $t3, 6, DrawSix
	beq $t3, 7, DrawSeven
	beq $t3, 8, DrawEight
	beq $t3, 9, DrawNine
#0
DrawZero:
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	j DrawNumEnd
#1
DrawOne:
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	j DrawNumEnd
#2
DrawTwo:
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	j DrawNumEnd
#3
DrawThree:
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	j DrawNumEnd
#4
DrawFour:
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	j DrawNumEnd
#5
DrawFive:
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	j DrawNumEnd
#6
DrawSix:
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	j DrawNumEnd
#7
DrawSeven:
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	j DrawNumEnd
#8
DrawEight:
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	j DrawNumEnd
#9
DrawNine:
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 8($t0)
	addi $t0, $t0, 512
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
DrawNumEnd:
	jr $ra


################ Draw Health and Score#######
DrawHS:
	li $t1, BASE
	li $t2, 0
	addi $t1, $t1, 55808
	lw $t3, Health
	lw $t5, MaxHealth
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	addi $t1, $t1, 16
# Draw Egg for remaining health
DrawHavePart:
	beq $t2, $t3, DrawLosePart
	add $t0, $t1, $zero
	jal DrawEgg
	addi $t1, $t1, 40
	addi $t2, $t2, 1
	j DrawHavePart
# Draw Broken Egg for Lost Health
DrawLosePart:
	beq $t2, $t5, DrawScore
	add $t0, $t1, $zero
	jal DrawBrokenEgg
	addi $t1, $t1, 40
	addi $t2, $t2, 1
	j DrawLosePart
	
# Draw the score
DrawScore:
	addi $t1, $s0, 56228
	lw $t5, Score
	li $t2, 5
DrawScoreLoop:
	div $t5, $t5, 10
	mfhi $t3
	mflo $t5
	addi $t0, $t1, 0
	jal DrawNum
DrawScoreLoopUpdate:
	addi $t1, $t1, -20
	addi $t0, $t1, 0
	addi $t2, $t2, -1
	bnez $t2, DrawScoreLoop
		
DrawHealthScoreEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

################# Draw Word Health and Score ########
DrawWordHS:
	li $t4, WHITE
	#H
	addi $t1, $zero, 55808
	addi $t1, $t1, 3584
	add $t1, $t1, $s0
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#A
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#L
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#T
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)
	
	#H
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#S
	addi $t1, $t1, 200
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#C
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#O
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#R
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	jr $ra

############################ Draw the words about entering levels, completing all levels or game over ###########

############## Level One #######################
DrawWordOne:
	li $t4, WHITE
	addi $t1, $s0, 29316
	addi $t0, $t1, 0
	#L
	sw $t4, 0($t0)  

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#V
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 4($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#L
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#O
	addi $t1, $t1, 52
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#N
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	
	li $t4, 0
	jr $ra

################ Level Two #####################
DrawWordTwo:
	li $t4, WHITE
	addi $t1, $s0, 29316
	addi $t0, $t1, 0
	#L
	sw $t4, 0($t0)  

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#V
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 4($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#L
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#T
	addi $t1, $t1, 52
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)
	
	#W
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 4($t0)
	sw $t4, 12($t0)
	
	#O
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	
	li $t4, 0
	jr $ra
	
############### Level Three ###################
DrawWordThree:
	li $t4, WHITE
	addi $t1, $s0, 29292
	addi $t0, $t1, 0
	#L
	sw $t4, 0($t0)  

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#V
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 4($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#L
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#T
	addi $t1, $t1, 52
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)
	
	#H
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#R
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	
	li $t4, 0
	jr $ra
	
############### Finish All the Level ##########
DrawVictory:
	li $t4, WHITE
	addi $t1, $s0, 29244
	addi $t0, $t1, 0
	#C
	sw $t4, 0($t0) 
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0) 

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#O
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#N
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#G
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#R
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#A
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#T
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)
	
	#U
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#L
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#A
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#T
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)
	
	#I
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 4($t0)
	sw $t4, 8($t0) 
	sw $t4, 12($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	
	#O
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#N
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#!
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	
	#Y
	addi $t1, $s0, 32928
	addi $t0, $t1, 0
	sw $t4, 0($t0)  
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 4($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	#O
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#U
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#W
	addi $t1, $t1, 52
	add $t0, $t1, $zero
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 4($t0)
	sw $t4, 12($t0)
	
	#I
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 4($t0)
	sw $t4, 8($t0) 
	sw $t4, 12($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	
	#N
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#!
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	
	li $t4, 0
	jr $ra
	

############### Draw Game Over ################
DrawGameOver:
	li $t4, WHITE
	addi $t1, $s0, 29316
	addi $t0, $t1, 0
	#G
	sw $t4, 0($t0)  
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#A
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#M
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#O
	addi $t1, $t1, 52
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#V
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 4($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 8($t0)
	
	#E
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
	#R
	addi $t1, $t1, 28
	add $t0, $t1, $zero
	sw $t4, 0($t0)  
	sw $t4, 4($t0) 
	sw $t4, 8($t0) 
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, WIDTH
	sw $t4, 0($t0)
	sw $t4, 16($t0)
	
	li $t4, 0
	jr $ra
	

################### Shot By Player ###################

############### Check Whether Player can Shot and if can, generate the shot ####################
CheckShot:
	li $t0, 0
	lw $t1, ShotDelay
	beqz $t1, CheckShotYes
# If shot delay is not zero, don't shot
CheckShotNo:
	addi $t1, $t1, -1
	sw $t1, ShotDelay
	j CheckShotEnd
CheckShotYes: 
	addi $t1, $zero, 3
	sw $t1, ShotDelay	
CheckShotLoop:
	lw $t1, ShotX($t0)
	lw $t2, ShotY($t0)
	bgez $t1, CheckShotLoopUpdate
	lw $t3, PlayerPos
	blt $t3, $zero, CheckShotLeft
CheckShotRight:
	addi $t1, $t8, 5
	addi $t2, $t9, 2
	sw $t1, ShotX($t0)
	sw $t2, ShotY($t0)
	sw $t3, ShotPos($t0)
	j CheckShotEnd
CheckShotLeft:
	addi $t1, $t8, -1
	addi $t2, $t9, 2
	sw $t1, ShotX($t0)
	sw $t2, ShotY($t0)
	sw $t3, ShotPos($t0)
	j CheckShotEnd
CheckShotLoopUpdate:
	addi $t0, $t0, 4
	blt $t0, MAX_Shot_By4, CheckShotLoop
CheckShotEnd:
	jr $ra
	
	
################ Check Shot when you press K #########
CheckShotK:
	li $t0, 0	
CheckShotKLoop:
	lw $t1, ShotX($t0)
	lw $t2, ShotY($t0)
	bgez $t1, CheckShotKLoopUpdate

	addi $t1, $t8, 2
	addi $t2, $t9, 4
	sw $t1, ShotX($t0)
	sw $t2, ShotY($t0)
	li $t3, 2
	sw $t3, ShotPos($t0)
	j CheckShotKEnd
CheckShotKLoopUpdate:
	addi $t0, $t0, 4
	blt $t0, MAX_Shot_By4, CheckShotKLoop
CheckShotKEnd:
	jr $ra
	
################ Draw Shot for Player##############
DrawShot:
	li $t0, 0
	li $t1, ORANGE
DrawShotLoop:
	lw $t2, ShotX($t0)
	lw $t3, ShotY($t0)
	lw $t4, ShotPos($t0)
	bltz $t2, DrawShotLoopUpdate
	bltz $t4,DrawShotLeft
	beq $t4, 1, DrawShotRight
#Down Shot
DrawShotDown:
	addi $t3, $t3, 1
	sw $t3, ShotY($t0)
	addi $t4, $zero, WIDTH
	mult $t3, $t4
	mflo $t3
	addi $t4, $zero, UNIT_WIDTH
	mult $t2, $t4
	mflo $t2
	add $t2, $t2, $t3
	add $t2, $t2, $s0
	lw $t4, 0($t2)
	sw $zero, -512($t2) 
	beq $t4, PLATFORM, DrawShotHitPlatform
	sw $t1, 0($t2) 
	j DrawShotLoopUpdate
#Right Shot
DrawShotRight:
	addi $t2, $t2, 1
	sw $t2, ShotX($t0)
	add $t5, $t2, $zero
	addi $t4, $zero, WIDTH
	mult $t3, $t4
	mflo $t3
	addi $t4, $zero, UNIT_WIDTH
	mult $t2, $t4
	mflo $t2
	add $t2, $t2, $t3
	add $t2, $t2, $s0
	bgt $t5, MAX_XINDEX, ClearShotRight
	lw $t4, 0($t2)
	sw $zero, -4($t2) 
	beq $t4, PLATFORM, DrawShotHitPlatform
	sw $t1, 0($t2) 
	j DrawShotLoopUpdate
#If reach boundary, clear right shot
ClearShotRight:
	sw $zero, -4($t2) 
	sw $zero, 0($t2) 
	li $t2, -1
	sw $t2, ShotX($t0)
	sw $t2, ShotY($t0)
	sw $zero, ShotPos($t0)
	j DrawShotLoopUpdate
# Left Shot
DrawShotLeft:
	addi $t2, $t2, -1
	sw $t2, ShotX($t0)
	add $t5, $t2, $zero
	addi $t4, $zero, WIDTH
	mult $t3, $t4
	mflo $t3
	addi $t4, $zero, UNIT_WIDTH
	mult $t2, $t4
	mflo $t2
	add $t2, $t2, $t3
	add $t2, $t2, $s0
	bltz $t5, ClearShotLeft
	lw $t4, 0($t2)
	sw $zero, 4($t2) 
	beq $t4, PLATFORM, DrawShotHitPlatform
	sw $t1, 0($t2) 
	j DrawShotLoopUpdate
# If reach boundary, clear left shot
ClearShotLeft:
	sw $zero, 4($t2) 
	sw $zero, 0($t2) 
	li $t2, -1
	sw $t2, ShotX($t0)
	sw $t2, ShotY($t0)
	sw $zero, ShotPos($t0)
	j DrawShotLoopUpdate
# If hit Platform, remove the shot
DrawShotHitPlatform:
	li $t2, -1
	sw $t2, ShotX($t0)
	sw $t2, ShotY($t0)
	sw $zero, ShotPos($t0)
DrawShotLoopUpdate:
	addi $t0, $t0, 4
	blt $t0, MAX_Shot_By4, DrawShotLoop
DrawShotEnd:
	jr $ra

############## Check Hit Enemy ###############	
CheckHitEnemy:
	li $t3, 0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
CheckHitShotLoop:
	lw $t4, ShotX($t3)
	lw $t5, ShotY($t3)
	bltz $t4, CheckHitShotLoopUpdate
	
	li $t2, 0
CheckHitEnemyLoop:
	lw $s3, EnemyType($t2)
	beqz $s3, CheckHitEnemyLoopUpdate
	lw $t0, EnemyX($t2)
	lw $t1, EnemyY($t2)
	blt $t4, $t0, CheckHitEnemyLoopUpdate
	addi $t0, $t0, 4
	bgt $t4, $t0, CheckHitEnemyLoopUpdate
	blt $t5, $t1, CheckHitEnemyLoopUpdate
	addi $t1, $t1, 4
	bgt $t5, $t1, CheckHitEnemyLoopUpdate

	# Kill Enemy if Enemy is not type three with armor without being freezed
	lw $s2, Frozen
	bnez $s2, HitandKill
	beq $s3, 3, HitEnemyThree
	beq $s3, 4, HitEnemyThreeBroken
# Kill Enemy
HitandKill:
	addi $t0, $t0, -4 
	addi $t1, $t1, -4
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	jal ClearEnemy
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	sw $zero, EnemyType($t2)
	j CheckHitClearShot
# When hit enemy three, deal damage to armor
HitEnemyThree:
	li $s3, 4
	sw $s3, EnemyType($t2)
	j CheckHitClearShot
HitEnemyThreeBroken:
	li $s3, 1
	sw $s3, EnemyType($t2)
# Clear the shot after hit enemy
CheckHitClearShot:
	li $t1, BASE
	addi $t0, $zero, WIDTH
	mult $t5, $t0
	mflo $t5
	addi $t0, $zero, UNIT_WIDTH
	mult $t4, $t0
	mflo $t4
	add $t4, $t4, $t5
	add $t4, $t4, $t1
	sw $zero, -4($t4)
	sw $zero, 0($t4) 
	sw $zero, 4($t4)
	li $t4, -1
	sw $t4, ShotX($t3)
	sw $t4, ShotY($t3)
	sw $zero, ShotPos($t3)
	lw $t4, Score
	addi $t4, $t4, 150
	sw $t4, Score
	j CheckHitShotLoopUpdate
	
CheckHitEnemyLoopUpdate:
	addi $t2, $t2, 4
	bne $t2, 32, CheckHitEnemyLoop
	
CheckHitShotLoopUpdate:
	addi $t3, $t3, 4
	blt $t3, MAX_Shot_By4, CheckHitShotLoop
	
CheckHitEnemyEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

################### Check Drop Condition ###################
#Check whether to drop by two units, one units or no drop according to whether 
#there exists platform below
CheckDrop:
	bnez $s5, CheckDrop_End
	bltz $a1, CheckDrop_End
	addi $t2, $zero, WIDTH
	addi $t1, $t1, 5
	add $t1, $t1, $a1
	mult $t1, $t2
	mflo $t1
	addi $t2, $zero, UNIT_WIDTH
	mult $t0, $t2
	mflo $t0
	add $t0, $t1, $t0
	add $t0, $t0, $s0

	li $t4, PLATFORM

	lw $t3, 0($t0)
	beq $t3, $t4, CheckDrop_No
	lw $t3, 16($t0)
	beq $t3, $t4, CheckDrop_No

	addi $t0, $t0, WIDTH
	lw $t3, 0($t0)
	beq $t3, $t4, CheckDrop_ONE
	lw $t3, 16($t0)
	beq $t3, $t4, CheckDrop_ONE
#no platform in two units below the character
CheckDrop_TWO:
	addi $a1, $a1, Fall_Speed
	j CheckDrop_End
#platform in one unit below the character
CheckDrop_ONE:
	addi $a1, $a1, 1
	li $s4, 1
	sw $s4, DoubleJump
	j CheckDrop_End
CheckDrop_No:
	li $s4, 1
	sw $s4, DoubleJump
CheckDrop_End:
	jr $ra

################### Check Jump Condition ###################
#Check whether a player can double jump, single jump or not according to whether there is a platform below
# and whether it falls down from platform or have used double jump
CheckJump:
	lw $s4, DoubleJump
	addi $t3, $zero, WIDTH
	addi $t2, $t2, 5
	mult $t2, $t3
	mflo $t2
	addi $t3, $zero, UNIT_WIDTH
	mult $t1, $t3
	mflo $t1
	add $t1, $t1, $t2
	add $t0, $t1, $s0
	
	li $t4, PLATFORM
	lw $t3, 0($t0)
	beq $t3, $t4, CheckJump_Yes
	lw $t3, 16($t0)
	beq $t3, $t4, CheckJump_Yes
	bnez $s4, CheckJump_Yes_Air
	
CheckJump_No:
	li $a3, 0
	jr $ra
CheckJump_Yes_Air:
	li $s4, 0
	sw $s4, DoubleJump
CheckJump_Yes:
	blt $t9, $a3, CheckJump_Bound
	sub $a3, $zero, $a3
	j CheckJump_End
CheckJump_Bound:
	sub $a3, $zero, $t9
CheckJump_End:
	jr $ra
	
################### Check Press S Condition ###################
#To prevent player to press S to drop down from the base platform
CheckS:
	add $t0, $t8, $zero
	add $t1, $t9, $zero
	addi $t2, $zero, WIDTH
	addi $t1, $t1, 5
	mult $t1, $t2
	mflo $t1
	addi $t2, $zero, UNIT_WIDTH
	mult $t0, $t2
	mflo $t0
	add $t0, $t1, $t0
	add $t0, $t0, $s0
	
	li $t4, PLATFORM
	lw $t3, 0($t0)
	bne $t3, $t4, CheckS_End
CheckS_No:
	li $t4, 0
	sw $t4, PlayerDY
CheckS_End:
	jr $ra
	

############### # HandleKeyPress     ################
Keypress:
	li $v0, 1
	li $v1, -1
	li $a3, 12
	li $t0, Keypress_base 
	lw $t0, 4($t0) 
# Press A to move left
KeypressA:
	bne $t0, 0x61, KeypressD
	beqz $t8, KeypressD
	li $t1, -1
	sw $t1, PlayerPos
	sw $v1, PlayerDX
# Press D to move right
KeypressD:
	bne $t0, 0x64, KeypressW
	beq $t8, Player_X_Bound, KeypressW
	li $t1, 1
	sw $t1, PlayerPos
	sw $v0, PlayerDX
# Press W to jump 
KeypressW:
	bne $t0, 0x77, KeypressS
	beqz $t8, KeypressS
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	add $t1, $t8, $zero
	add $t2, $t9, $zero
	jal CheckJump
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	sw $a3, PlayerDY
# Press S to accelerate falling
KeypressS:
	bne $t0, 0x73, KeypressP
	beq $t8, Player_Y_Bound, KeypressP
	sw $v0, PlayerDY
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal CheckS
	lw $ra, 0($sp)
	addi $sp, $sp, 4
# Press P to restart game (From level one)
KeypressP:
	bne $t0, 0x70, KeypressJ
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal ClearScreen
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j main # Reset Game
# Press J to shoot
KeypressJ:
	bne $t0, 0x6a, KeypressK
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal CheckShot
	lw $ra, 0($sp)
	addi $sp, $sp, 4
# If you are in chicken form, you can press K to move up and shoot down
KeypressK:
	bne $t0, 0x6b, KeypressExit
	lw $t2, PlayerType
	beq, $t2, 0, KeypressExit
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal CheckShotK
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	ble $t9, 8, KeypressExit
	li $a3, -8
	sw $a3, PlayerDY
KeypressExit:
	jr $ra

################### Set Levels ###################

################ Set Level One ################
SetLevelOne:
	sw $zero, PlayerDX
	sw $zero, PlayerDY
	li $t1, 1
	sw $t1, PlayerPos
	sw $zero, PlayerType
	sw $zero, PlayerStatusT

	sw $zero, Score
	sw $t1, DoubleJump
	li $t1, 3
	sw $t1, Health

	li $a0, 0
	li $t1, -1
	li $t2, 1

	#Array[0]
	sw $zero, EnemyX($a0)
	li $t3, 84
	sw $t3, EnemyY($a0)
	sw $t2, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 32
	sw $t3, CoinX($a0)
	li $t3, 100
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	li $t3, 64
	sw $t3, PickupX($a0)
	li $t3, 96
	sw $t3, PickupY($a0)
	sw $t2, PickupType($a0)
	
	# Array[1]
	addi $a0, $a0, 4
	li $t3, 88
	sw $t3, EnemyX($a0)
	li $t3, 84
	sw $t3, EnemyY($a0)
	sw $t2, EnemyType($a0)
	sw $t2, EnemyPos($a0)
	li $t3, 114
	sw $t3, CoinX($a0)
	li $t3, 100
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	li $t3, 52
	sw $t3, PickupX($a0)
	li $t3, 60
	sw $t3, PickupY($a0)
	li $t3, 2
	sw $t3, PickupType($a0)
	
	#Array[2]
	addi $a0, $a0, 4
	li $t3, 40
	sw $t3, EnemyX($a0)
	li $t3, 68
	sw $t3, EnemyY($a0)
	li $t3, 2
	sw $t3, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 16
	sw $t3, CoinX($a0)
	li $t3, 82
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	sw $t1, PickupX($a0)
	sw $t1, PickupY($a0)
	sw $zero, PickupType($a0)
	
	#Array[3]
	addi $a0, $a0, 4
	sw $zero, EnemyX($a0)
	li $t3, 52
	sw $t3, EnemyY($a0)
	sw $t2, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 65
	sw $t3, CoinX($a0)
	li $t3, 76
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	sw $t1, PickupX($a0)
	sw $t1, PickupY($a0)
	sw $zero, PickupType($a0)
	
	#Array[4]
	addi $a0, $a0, 4
	li $t3, 120
	sw $t3, EnemyX($a0)
	li $t3, 52
	sw $t3, EnemyY($a0)
	li $t3, 2
	sw $t3, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 65
	sw $t3, CoinX($a0)
	li $t3, 64
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	li $t3, 60
	sw $t3, PickupX($a0)
	li $t3, 16
	sw $t3, PickupY($a0)
	li $t3, 5
	sw $t3, PickupType($a0)
	
	#Array[5]
	addi $a0, $a0, 4
	li $t3, 84
	sw $t3, EnemyX($a0)
	li $t3, 36
	sw $t3, EnemyY($a0)
	sw $t2, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 4
	sw $t3, CoinX($a0)
	li $t3, 52
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	
	#Array[6]
	addi $a0, $a0, 4
	sw $t1, EnemyX($a0)
	sw $t1, EnemyY($a0)
	sw $zero, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 16
	sw $t3, CoinX($a0)
	li $t3, 38
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	
	#Array[7]
	addi $a0, $a0, 4
	sw $t1, EnemyX($a0)
	sw $t1, EnemyY($a0)
	sw $zero, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 72
	sw $t3, CoinX($a0)
	li $t3, 36
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	
	sw $zero, Frozen
	sw $zero, GotHit
	sw $t2, ShotDelay
	sw $t2, GameOver
	sw $zero, Victory
	sw $zero, Complete
	li $t3, 2
	sw $t3, NextLevel
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal DrawPlatformLevelOne
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra

################ Set Level Two ################
SetLevelTwo:
	sw $zero, PlayerDX
	sw $zero, PlayerDY
	li $t1, 1
	sw $t1, PlayerPos


	sw $t1, DoubleJump

	li $a0, 0
	li $t1, -1
	li $t2, 1

	#Array[0]
	li $t3, 100
	sw $t3, EnemyX($a0)
	li $t3, 84
	sw $t3, EnemyY($a0)
	sw $t2, EnemyType($a0)
	sw $t2, EnemyPos($a0)
	li $t3, 60
	sw $t3, CoinX($a0)
	li $t3, 100
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	li $t3, 64
	sw $t3, PickupX($a0)
	li $t3, 64
	sw $t3, PickupY($a0)
	sw $t2, PickupType($a0)
	
	# Array[1]
	addi $a0, $a0, 4
	li $t3, 120
	sw $t3, EnemyX($a0)
	li $t3, 84
	sw $t3, EnemyY($a0)
	li $t3, 2
	sw $t3, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 60
	sw $t3, CoinX($a0)
	li $t3, 84
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	li $t3, 48
	sw $t3, PickupX($a0)
	li $t3, 28
	sw $t3, PickupY($a0)
	li $t3, 2
	sw $t3, PickupType($a0)
	
	#Array[2]
	addi $a0, $a0, 4
	li $t3, 20
	sw $t3, EnemyX($a0)
	li $t3, 52
	sw $t3, EnemyY($a0)
	li $t3, 2
	sw $t3, EnemyType($a0)
	sw $t2, EnemyPos($a0)
	li $t3, 80
	sw $t3, CoinX($a0)
	li $t3, 84
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	li $t3, 96
	sw $t3, PickupX($a0)
	li $t3, 36
	sw $t3, PickupY($a0)
	li $t3, 3
	sw $t3, PickupType($a0)
	
	#Array[3]
	addi $a0, $a0, 4
	li $t3, 40
	sw $t3, EnemyX($a0)
	li $t3, 52
	sw $t3, EnemyY($a0)
	li $t3, 3
	sw $t3, EnemyType($a0)
	sw $t2, EnemyPos($a0)
	li $t3, 4
	sw $t3, CoinX($a0)
	li $t3, 44
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	sw $t1, PickupX($a0)
	sw $t1, PickupY($a0)
	sw $zero, PickupType($a0)
	
	#Array[4]
	addi $a0, $a0, 4
	li $t3, 60
	sw $t3, EnemyX($a0)
	li $t3, 52
	sw $t3, EnemyY($a0)
	li $t3, 2
	sw $t3, EnemyType($a0)
	sw $t2, EnemyPos($a0)
	li $t3, 16
	sw $t3, CoinX($a0)
	li $t3, 48
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	li $t3, 120
	sw $t3, PickupX($a0)
	li $t3, 16
	sw $t3, PickupY($a0)
	li $t3, 5
	sw $t3, PickupType($a0)
	
	#Array[5]
	addi $a0, $a0, 4
	li $t3, 84
	sw $t3, EnemyX($a0)
	li $t3, 36
	sw $t3, EnemyY($a0)
	li $t3, 2
	sw $t3, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 64
	sw $t3, CoinX($a0)
	li $t3, 52
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	
	#Array[6]
	addi $a0, $a0, 4
	sw $t1, EnemyX($a0)
	sw $t1, EnemyY($a0)
	sw $zero, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 24
	sw $t3, CoinX($a0)
	li $t3, 36
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	
	#Array[7]
	addi $a0, $a0, 4
	sw $t1, EnemyX($a0)
	sw $t1, EnemyY($a0)
	sw $zero, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 100
	sw $t3, CoinX($a0)
	li $t3, 36
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	
	sw $zero, Frozen
	sw $zero, GotHit
	sw $t2, ShotDelay
	sw $t2, GameOver
	sw $zero, Complete
	li $t3, 3
	sw $t3, NextLevel
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal DrawPlatformLevelTwo
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	li $t8, 8
	li $t9, 100
	li $s6, 10
	li $s5, 0

	jr $ra
	
################ Set Level Three ################
SetLevelThree:
	sw $zero, PlayerDX
	sw $zero, PlayerDY
	li $t1, 1
	sw $t1, PlayerPos


	sw $t1, DoubleJump

	li $a0, 0
	li $t1, -1
	li $t2, 1

	#Array[0]
	li $t3, 32
	sw $t3, EnemyX($a0)
	li $t3, 84
	sw $t3, EnemyY($a0)
	li $t3, 3
	sw $t3, EnemyType($a0)
	sw $t2, EnemyPos($a0)
	li $t3, 60
	sw $t3, CoinX($a0)
	li $t3, 100
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	li $t3, 60
	sw $t3, PickupX($a0)
	li $t3, 94
	sw $t3, PickupY($a0)
	sw $t2, PickupType($a0)
	
	# Array[1]
	addi $a0, $a0, 4
	li $t3, 96
	sw $t3, EnemyX($a0)
	li $t3, 84
	sw $t3, EnemyY($a0)
	li $t3, 3
	sw $t3, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 12
	sw $t3, CoinX($a0)
	li $t3, 84
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	li $t3, 8
	sw $t3, PickupX($a0)
	li $t3, 60
	sw $t3, PickupY($a0)
	li $t3, 2
	sw $t3, PickupType($a0)
	
	#Array[2]
	addi $a0, $a0, 4
	li $t3, 40
	sw $t3, EnemyX($a0)
	li $t3, 68
	sw $t3, EnemyY($a0)
	li $t3, 3
	sw $t3, EnemyType($a0)
	sw $t2, EnemyPos($a0)
	li $t3, 108
	sw $t3, CoinX($a0)
	li $t3, 84
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	li $t3, 112
	sw $t3, PickupX($a0)
	li $t3, 60
	sw $t3, PickupY($a0)
	li $t3, 3
	sw $t3, PickupType($a0)
	
	#Array[3]
	addi $a0, $a0, 4
	li $t3, 60
	sw $t3, EnemyX($a0)
	li $t3, 68
	sw $t3, EnemyY($a0)
	li $t3, 2
	sw $t3, EnemyType($a0)
	sw $t2, EnemyPos($a0)
	li $t3, 20
	sw $t3, CoinX($a0)
	li $t3, 68
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	sw $t1, PickupX($a0)
	sw $t1, PickupY($a0)
	sw $zero, PickupType($a0)
	
	#Array[4]
	addi $a0, $a0, 4
	li $t3, 80
	sw $t3, EnemyX($a0)
	li $t3, 68
	sw $t3, EnemyY($a0)
	li $t3, 3
	sw $t3, EnemyType($a0)
	sw $t2, EnemyPos($a0)
	li $t3, 100
	sw $t3, CoinX($a0)
	li $t3, 68
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	li $t3, 60
	sw $t3, PickupX($a0)
	li $t3, 10
	sw $t3, PickupY($a0)
	li $t3, 5
	sw $t3, PickupType($a0)
	
	#Array[5]
	addi $a0, $a0, 4
	li $t3, 52
	sw $t3, EnemyX($a0)
	li $t3, 52
	sw $t3, EnemyY($a0)
	li $t3, 2
	sw $t3, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 40
	sw $t3, CoinX($a0)
	li $t3, 52
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	
	#Array[6]
	addi $a0, $a0, 4
	li $t3, 72
	sw $t3, EnemyX($a0)
	li $t3, 52
	sw $t3, EnemyY($a0)
	li $t3, 2
	sw $t3, EnemyType($a0)
	sw $t2, EnemyPos($a0)
	li $t3, 80
	sw $t3, CoinX($a0)
	li $t3, 52
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	
	#Array[7]
	addi $a0, $a0, 4
	li $t3, 64
	sw $t3, EnemyX($a0)
	li $t3, 36
	sw $t3, EnemyY($a0)
	sw $t2, EnemyType($a0)
	sw $t1, EnemyPos($a0)
	li $t3, 60
	sw $t3, CoinX($a0)
	li $t3, 36
	sw $t3, CoinY($a0)
	sw $t2, CoinExist($a0)
	sw $t1, ShotX($a0)
	sw $t1, ShotY($a0)
	sw $zero, ShotPos($a0)
	sw $t1, EnemyShotX($a0)
	sw $t1, EnemyShotY($a0)
	sw $zero, EnemyShotPos($a0)
	
	sw $zero, Frozen
	sw $zero, GotHit
	sw $t2, ShotDelay
	sw $t2, GameOver
	sw $zero, Complete
	li $t3, 4
	sw $t3, NextLevel
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal DrawPlatformLevelThree
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	li $t8, 8
	li $t9, 100
	li $s6, 10
	li $s5, 0

	jr $ra
	
############# When reach the final Destination, Jump to Next Level ##########3
CheckPassLevel:
	lw $t0, Complete
	beqz $t0, CheckPassLevelEnd
GotoNextLevel:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	lw $t0, NextLevel
	beq $t0, 2, Level2
	beq $t0, 3, Level3
# When you reach final destination of Level 3, you finished all the levels
LevelComplete:
	jal ClearScreen
	jal DrawVictory
	li $t0, 1
	sw $t0, Victory
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j CheckPassLevelEnd
Level3:
	jal ClearScreen
	jal DrawWordThree
	li $v0, 32
	li $a0, 2000 # Wait two seconds to set the screen
	syscall
	jal ClearScreen
	jal SetLevelThree
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j Gameloop
Level2:
	jal ClearScreen
	jal DrawWordTwo
	li $v0, 32
	li $a0, 2000 # Wait two seconds to set the screen
	syscall
	jal ClearScreen
	jal SetLevelTwo
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j Gameloop
CheckPassLevelEnd:
	jr $ra


############# Main Process ###################
.globl main
main:
li $s0, BASE

# Set the condition for Level One
jal DrawWordOne
li $v0, 32
li $a0, 2000 # Wait two seconds to set the screen
syscall
jal ClearScreen
jal SetLevelOne

# Store the position of Player in $t8 (PlayerX) and $t9 (PlayerY)
li $t8, 8
li $t9, 100
# If $s5 = 0, Enemy will Move
li $s6, 10
li $s5, 0
jal DrawBase
jal DrawWordHS


Gameloop:

	sw $zero, PlayerDX
	sw $zero, PlayerDY
	# Check the keypress and if have, responds to them
	lw $t0, Keypress_base
	bne $t0, 1, NoKeypress
	jal Keypress
	j AfterKeypress
NoKeypress:
AfterKeypress:
	# Draw Health and Score
	jal DrawHS
	# If You reached the destination of Level 3, you win the game
	lw $t0, Victory
	bnez $t0, FrameUpdate
	# When you lose all HP, Game Over
	lw $t0, GameOver
	beqz $t0, FrameUpdate
	lw $t0, Health
	bnez $t0, GameContinue
	li $t0, 0
	sw $t0, GameOver
	jal DrawGameOver
	j FrameUpdate

GameContinue:
	# Check whether you have finished current level
	jal CheckPassLevel
	# Check the remaining time of special status, chicken and frozen
	jal CheckStatusTime
	# Check whether Player have picked up the coins
	jal CheckCoin
	# Draw the existing coins
	jal DrawAllCoin
	# Check Whether player has picked the pickups
	jal CheckPickup
	# Draw all existing pickups
	jal DrawAllPickup
	# Check whether Player collides with enemies
	jal CheckEnemyCollision
	# Check whether green enemies will shot
	jal CheckEnemyShot
	# Check whether player is hit by enemy shots
	jal CheckHitPlayer
	# Draw Existing Enemy Shots (in green)
	jal DrawEnemyShot
	# Check whether Player have hit the enemies
	jal CheckHitEnemy
	# Update the position and status of enemies
	jal UpdateEnemy
	# Draw Existing enemies
	jal DrawEnemy
	# Draw Player Shots (in orange)
	jal DrawShot
	lw $t6, PlayerDX
	lw $t7, PlayerDY
	add $a1, $t7, $zero
	add $t0, $t8, $zero
	add $t1, $t9, $zero
	# Check whether player will fall accorinng to player jump
	jal CheckDrop
	move $t7, $a1

	or $t4, $t6, $t7
	# Check whether player has moved and if don't move, don't clear player
	beqz $t4, NoClear
	jal ClearPlayer
NoClear:
	# Draw Current Player
	add $t8, $t8, $t6
	add $t9, $t9, $t7
	jal Drawplayer
# Suspend the iteration by sleeping for 33 milliseconds
FrameUpdate:
	li $v0, 32
	li $a0, MS_PER_FRAME
	syscall
# After finishing all the operations, branch to the gameloop to continue
FrameUpdateEnd:
	addi $s5, $s5, 1
	bne $s5, $s6, no_reset_s5
	li $s5, 0
no_reset_s5:
	j Gameloop
	
	li $v0, 10
	syscall
