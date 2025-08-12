extends Node
class_name T_StartInventory

var wAtts: Array[T_StartWeaponAttachment] = [] # nao pode ser assim pq tem q ser uma lista de attachments // no total é uma matriz, o indice exterior eh referente a arma, e o indice interior é referente aos attachments
# E SE O TIPO DE ATTACHMENT JA ESTIVER DEFINIDO NO WeaponAttachmentList?
# COMO PROPRIEDADES, EX: SIGHT: STRING = PATH_DO_ATTACHMENT???????
# ASSIM REDUZIRIA A QUANTIDADE DE CLASSES E JA TERIA UM ACESSO DIRETO A QUAL ATT ESTÁ EM CADA SLOT

var weapons: Array[String] = []
var weaponAttachments: Array[String] = []
var reserveAmmo: Array = [0, 0, 0, 0]        # cada indice eh um tipo de municao
var keyItems: Array = []
var misc: Array = []
