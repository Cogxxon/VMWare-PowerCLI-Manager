<####################################################
o---|-Name: Write-SegmentedLine
o---|-Auther: Garvey Snow
o---|-Version: 0.1b
o---|-Description: Short for write segmented line is a wrapper for the cmdlet write-host
             Makes it eaiser
o---|-Dependancies: none
#####################################################>
function WRITE-SEGLINE{
    # Set Parems
    param(
           [int][parameter(Mandatory=$true)][Alias('nl')]$numlines,
          #---------
           [string[]][parameter(Mandatory=$false)][Alias('c')]$color,
          #---------
           [string[]][parameter(Mandatory=$true)][Alias('fl')]$firstline,
          #---------
           [string[]][parameter(Mandatory=$false)][Alias('sl')]$secondline,
          #---------
           [string[]][parameter(Mandatory=$false)][Alias('tl')]$thirdline,
          #---------
           [string[]][parameter(Mandatory=$false)][Alias('fhl')]$fourthline,
          #---------
           [string[]][parameter(Mandatory=$false)][Alias('ffhl')]$fifthline,
          #---------
           [switch][parameter(Mandatory=$false)][Alias('a')]$Action,
          #---------
           [switch][parameter(Mandatory=$false)][Alias('r')]$response,
          #---------
           [switch][parameter(Mandatory=$false)][Alias('e')]$error,
          #---------
           [switch][parameter(Mandatory=$false)][Alias('n')]$Notification,
          #---------
           [switch][parameter(Mandatory=$false)][Alias('ri')]$requestinput,
          #---------
           [switch][parameter(Mandatory=$false)][Alias('nnl')]$nonewline
           )

    # set default color
    if($color.length -lt 1 ){ $color = "Gray" }

    # one line write
    if($numlines -eq 1)
    {
        # Line write supporting single value
        if($Notification)
        {
            write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
            write-host -ForegroundColor DarkRed 'Notification' -nonewline; 
            write-host -ForegroundColor DarkCyan '--------<(  ' -NoNewline; 
            write-host -ForegroundColor $color $firstline -NoNewline;
            if($nonewline){ write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine; } 
            else { write-host -ForegroundColor DarkCyan ' ) ' }
        }
        if($requestinput)
        {
            write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
            write-host -ForegroundColor DarkGreen 'Request User Input' -nonewline; 
            write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline; 
            write-host -ForegroundColor $color $firstline -NoNewline; 
            if($nonewline){ write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine; } 
            else { write-host -ForegroundColor DarkCyan ' ) ' }
        }
        if($error){
            write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
            write-host -ForegroundColor red 'Error Exception' -nonewline; 
            write-host -ForegroundColor DarkCyan '------<(  ' -NoNewline; 
            write-host -ForegroundColor $color $firstline -NoNewline; 
            if($nonewline){ write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine; } 
            else { write-host -ForegroundColor DarkCyan ' ) ' }       
        }
        if($Action){
            write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
            write-host -ForegroundColor Blue 'Action' -nonewline; 
            write-host -ForegroundColor DarkCyan '---------<(  ' -NoNewline; 
            write-host -ForegroundColor $color $firstline -NoNewline; 
            if($nonewline){ write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine; } 
            else { write-host -ForegroundColor DarkCyan ' ) ' }       
        }
        if($response){
            write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
            write-host -ForegroundColor yellow 'response' -nonewline; 
            write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline; 
            write-host -ForegroundColor $color $firstline -NoNewline; 
            if($nonewline){ write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine; } 
            else { write-host -ForegroundColor DarkCyan ' ) ' }       
        }
    }
   # two line write
   if($numlines -eq 2)
   {
        # Line write supporting single value
        if($Notification)
        {
            write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
            write-host -ForegroundColor DarkRed 'Notification' -nonewline; 
            write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline; 
            write-host -ForegroundColor $color $firstline -NoNewline; 
            write-host -ForegroundColor DarkCyan ' ) ' -nonewline; 
            write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline; 
            write-host -ForegroundColor Magenta $secondline -NoNewline; 
            if($nonewline){ write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine; } 
            else { write-host -ForegroundColor DarkCyan ' ) ' }
        }
        if($requestinput)
        {
            write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
            write-host -ForegroundColor DarkGreen 'Request User Input' -nonewline;
            write-host -ForegroundColor DarkCyan '--< ' -NoNewline; 
            write-host -ForegroundColor $color $firstline -NoNewline; 
            write-host -ForegroundColor DarkCyan ' ) ' -nonewline; 
            write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline; 
            write-host -ForegroundColor Magenta $secondline -NoNewline; 
            if($nonewline){ write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine; } 
            else { write-host -ForegroundColor DarkCyan ' ) ' }
        }
        if($error)
        {
            write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
            write-host -ForegroundColor Red 'Error Exception' -nonewline; 
            write-host -ForegroundColor DarkCyan '--< ' -NoNewline; 
            write-host -ForegroundColor $color $firstline -NoNewline; 
            write-host -ForegroundColor DarkCyan ' ) ' -nonewline; 
            write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline; 
            write-host -ForegroundColor Magenta $secondline -NoNewline; 
            if($nonewline){ write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine; } 
            else { write-host -ForegroundColor DarkCyan ' ) ' }
        }
        if($Action)
        {
            write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
            write-host -ForegroundColor Blue 'Action' -nonewline; 
            write-host -ForegroundColor DarkCyan '--< ' -NoNewline; 
            write-host -ForegroundColor $color $firstline -NoNewline; 
            write-host -ForegroundColor DarkCyan ' ) ' -nonewline; 
            write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline; 
            write-host -ForegroundColor Magenta $secondline -NoNewline; 
            if($nonewline){ write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine; } 
            else { write-host -ForegroundColor DarkCyan ' ) ' }
        }
        if($response)
        {
            write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
            write-host -ForegroundColor DarkGreen 'response' -nonewline; 
            write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline; 
            write-host -ForegroundColor $color $firstline -NoNewline; 
            write-host -ForegroundColor DarkCyan ' ) ' -nonewline; 
            write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline; 
            write-host -ForegroundColor Magenta $secondline -NoNewline; 
            if($nonewline) {write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine;}
            else {write-host -ForegroundColor DarkCyan ' ) '}
        }
   }
    # Three line write
    if($numlines -eq 3)
    {
    
        if($Notification)
        {
          
              write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
              write-host -ForegroundColor DarkRed 'Notification' -nonewline;
              write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline;
                write-host -ForegroundColor $color $firstline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Magenta $secondline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Green $thirdline -NoNewline;
              if($nonewline){write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine;}
              else{write-host -ForegroundColor DarkCyan ' ) ' }
    
        }
        if($Action)
        {
          
              write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
              write-host -ForegroundColor Blue 'Action ' -nonewline;
              write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline;
                write-host -ForegroundColor $color $firstline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Magenta $secondline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Green $thirdline -NoNewline;
              if($nonewline){
                 write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine;
              }else{
                 write-host -ForegroundColor DarkCyan ' ) ' 
              }
    
        }

    }#End Function

    # Three line write
    if($numlines -eq 4)
    {
        <#-------
        Notification
        ---------#>
        if($Notification)
        {
          
              write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
              write-host -ForegroundColor DarkRed 'Notification' -nonewline;
              write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline;
                write-host -ForegroundColor $color $firstline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Magenta $secondline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Green $thirdline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Green $fourthline -NoNewline;
              if($nonewline){
                 write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine;
              }else{
                 write-host -ForegroundColor DarkCyan ' ) ' 
              }
    
        }
        <#-------
        Action
        ---------#>
        if($Action)
        {
          
              write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
              write-host -ForegroundColor yellow 'Action' -nonewline;
              write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline;
                write-host -ForegroundColor $color $firstline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Magenta $secondline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Green $thirdline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Green $fourthline -NoNewline;
              if($nonewline){
                 write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine;
              }else{
                 write-host -ForegroundColor DarkCyan ' ) ' 
              }
    
        }

    }#End Function
    if($numlines -eq 5)
    {
        <#-------
        Notification
        ---------#>
        if($Notification)
        {
          
              write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
              write-host -ForegroundColor DarkRed 'Notification' -nonewline;
              write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline;
                write-host -ForegroundColor $color $firstline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Magenta $secondline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Green $thirdline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Green $fourthline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Green $fifthline -NoNewline;
              if($nonewline){
                 write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine;
              }else{
                 write-host -ForegroundColor DarkCyan ' ) ' 
              }
    
        }
        <#-------
        Action
        ---------#>
        if($Action)
        {
          
              write-host -ForegroundColor DarkCyan '---<(  ' -nonewline; 
              write-host -ForegroundColor Blue 'Action' -nonewline;
              write-host -ForegroundColor DarkCyan '---<(  ' -NoNewline;
                write-host -ForegroundColor $color $firstline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Magenta $secondline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Green $thirdline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Green $forthline -NoNewline;
              write-host -ForegroundColor DarkCyan ' ) ' -NoNewline;
              write-host -ForegroundColor DarkCyan ' ---<(  ' -NoNewline;
                write-host -ForegroundColor Green $fifthline -NoNewline;
              if($nonewline){
                 write-host -ForegroundColor DarkCyan ' ) ' -NoNewLine;
              }else{
                 write-host -ForegroundColor DarkCyan ' ) ' 
              }
    
        }

    }#End Function

   }
