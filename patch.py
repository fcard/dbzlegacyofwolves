original = bytearray(open("DBZL.gba", "rb").read())
modified = bytearray(open("a.gba", "rb").read())

modified_ranges = []
modified_ranges.append(range(0x22BC, 0x22BC+4))
modified_ranges.append(range(0x329C, 0x329C+6))
modified_ranges.append(range(0x7354, 0x7354+4))
modified_ranges.append(range(0x739A, 0x739A+2))
modified_ranges.append(range(0x73B0, 0x73B0+2))
modified_ranges.append(range(0x73C6, 0x73C6+2))
modified_ranges.append(range(0x74AE, 0x74AE+4))
modified_ranges.append(range(0x114A8, 0x114A8+(16*25)))
modified_ranges.append(range(0x0014BF00, 0x0014C4DC))
modified_ranges.append(range(0x006B61CC, 0x006B61CC+4))
modified_ranges.append(range(0x006B634C, 0x006B634C+4))
modified_ranges.append(range(0x006B638C, 0x006B638C+4))
modified_ranges.append(range(0x006B650C, 0x006B650C+4))
modified_ranges.append(range(0x006B68CC, 0x006B68CC+4))

final = original.copy()
for r in modified_ranges:
    final[r.start:r.stop] = modified[r.start:r.stop]


with open("final.gba", "wb") as final_file:
    for i in range(0, len(final)):
        final_file.write(final[i].to_bytes(1, byteorder='little'))

