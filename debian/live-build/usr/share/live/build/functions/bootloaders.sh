#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2016 Adrian Gibanel Lopez <adrian15sgd@gmail.com>
##
## This program comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.

Is_First_Bootloader ()
{
	EVAL_FIRST_BOOTLOADER="${1}"

	if [ "${LB_FIRST_BOOTLOADER}" = "${EVAL_FIRST_BOOTLOADER}" ]
	then
		return 0
	else
		return 1
	fi

}

Is_Bootloader ()
{
	EVAL_BOOTLOADER="${1}"
	OLDIFS="$IFS"
	IFS=","
	for BOOTLOADER in ${LB_BOOTLOADERS}
	do
		if [ "${BOOTLOADER}" = "${EVAL_BOOTLOADER}" ]
		then
			IFS="$OLDIFS"
			return 0
		fi
	done
	IFS="$OLDIFS"
	return 1
}

Is_Extra_Bootloader ()
{
	EVAL_EXTRA_BOOTLOADER="${1}"

	if Is_First_Bootloader "${EVAL_EXTRA_BOOTLOADER}"
	then
		return 1
	else
		if Is_Bootloader "${EVAL_EXTRA_BOOTLOADER}"
		then
			return 0
		fi
	fi
	return 1

}

Check_Non_First_Bootloader ()
{
	NON_FIRST_BOOTLOADER="${1}"

	if Is_First_Bootloader "${NON_FIRST_BOOTLOADER}"
	then
		Echo_error "Bootloader: ${NON_FIRST_BOOTLOADER} not supported as a first bootloader."
		exit 1
	else
		return 0
	fi
}


Check_Non_Extra_Bootloader ()
{
	NON_EXTRA_BOOTLOADER="${1}"

	if Is_Extra_Bootloader "${NON_EXTRA_BOOTLOADER}"
	then
		Echo_error "Bootloader: ${NON_EXTRA_BOOTLOADER} not supported as a extra bootloader."
		exit 1
	else
		return 0
	fi
}

Check_First_Bootloader_Role ()
{
	FIRST_BOOTLOADER_ROLE="${1}"
	Check_Non_Extra_Bootloader "${FIRST_BOOTLOADER_ROLE}"

	if Is_First_Bootloader "${FIRST_BOOTLOADER_ROLE}"
	then
		return 0
	else
		exit 0
	fi

}

Check_Extra_Bootloader_Role ()
{
	EXTRA_BOOTLOADER_ROLE="${1}"
	Check_Non_First_Bootloader "${EXTRA_BOOTLOADER_ROLE}"

	if Is_Extra_Bootloader "${EXTRA_BOOTLOADER_ROLE}"
	then
		return 0
	else
		exit 0
	fi

}

Check_Any_Bootloader_Role ()
{
	ANY_BOOTLOADER_ROLE="${1}"

	if Is_First_Bootloader "${ANY_BOOTLOADER_ROLE}"
	then
		return 0
	fi

	if Is_Extra_Bootloader "${ANY_BOOTLOADER_ROLE}"
	then
		return 0
	fi

	exit 0

}