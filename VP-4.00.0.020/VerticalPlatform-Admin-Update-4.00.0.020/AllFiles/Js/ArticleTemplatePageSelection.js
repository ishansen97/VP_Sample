function ConfirmPageChange(dropDownObject, previousSelection, emptyPageSelectionIndex)
{
    if (dropDownObject.selectedIndex != emptyPageSelectionIndex)
    {    
        if (! confirm('Associating a page to the Article type will reset the settings ' +
					    'of each Article Detail module in this page. Therefore it will require you to re configure ' + 
					    'the settings of each of those modules. Are you sure you want to continue'))
        {
            dropDownObject[previousSelection].selected = true;
            return false;
        }
    }
    return true;
}