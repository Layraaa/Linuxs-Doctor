#!/bin/bash
# generatehtml.sh
# Generate HTML report

function generatehtml(){
    
    ### GET DATA REPORT

    categories=$(grep "^\[@\] " -n "$datapath"/report.txt | cut -d ':' -f 1) # Get start of each category
    numberoflines=$(wc -l < "$datapath"/report.txt) # Get number of lines
    x=0 # Var that counter needs for change dinamically array positions
    var=() # Array that get information about report
    for i in $categories
    do
        count=$(("$x" * 3)) # Counter of array positions
        ((i++)) # Add 1 to category number, for jump until the next category
        searchlimit=$(sed ''$i','$numberoflines'!d' "$datapath"/report.txt | grep "^\[@\]" -n -m 1 | cut -d ':' -f 1) # Get number of next category
        searchlimit=$((searchlimit+i)) # Add difference

        if [ "$i" != "$searchlimit" ] # Get all numbers between start of category and next category, if is the last one, seq until the end of file
        then
            content=$(seq "$i" "$searchlimit")
        else
            content=$(seq "$i" "$numberoflines")
        fi
        for i2 in $content # For each number line:
        do
            if [[ $(sed ''$i2'!d' "$datapath"/report.txt | grep -oh "^\[@\]") == "[@]" || $(sed ''$i2'!d' "$datapath"/report.txt | grep -oh "^\[;\]") == "[;]" || $(sed ''$i2'!d' "$datapath"/report.txt | grep -oh "^Summary") == "Summary" ]] # Detect if loop jumped to next category or end the file
            then
                break
            elif [[ $(sed ''$i2'!d' "$datapath"/report.txt | grep -oh "^\[\*\]") == "[*]"  ]] # Add to var position if file wasn't modificated
            then
                var[0 + count]+=$(sed ''$i2'!d' "$datapath"/report.txt && echo "-")
                var[0 + count]=${var[0 + count]%?}
            elif [[ $(sed ''$i2'!d' "$datapath"/report.txt | grep -oh  "^\[?\]") == "[?]" ]] # Add to var position if file wasn't modificated
            then
                var[1 + count]+=$(sed ''$i2'!d' "$datapath"/report.txt && echo "-")
                var[1 + count]=${var[1 + count]%?}
            else
                var[2 + count]+=$(sed ''$i2'!d' "$datapath"/report.txt && echo "-")
                var[2 + count]=${var[2 + count]%?}
            fi
        done
        ((x++))
    done

    ### GET DATA REPORT

    grep "^\[@\]*" "$datapath"/report.txt | sed 's/\[@\] //' >> /lib/linuxsdoctor/temp.txt # Get categories
    varsname=($(sed 's/\[@\] //' /lib/linuxsdoctor/temp.txt | sed 's/comparisions//' | tr -d \'\" | tr -d : | sed -e 's/\s\+//g' | tr "[:upper:]" "[:lower:]")) # Get varsname of comparisions hits

    y=0 # Counter of vars position

    # Write metadata, style and, sidebar, body...
    echo "
    <html>
    <head>
        <meta charset='UTF-8'>
        <meta http-equiv='X-UA-Compatible' content='IE=edge'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx' crossorigin='anonymous'>
        <title>Linux's Doctor - Report $date</title>

        <style>
        #header{
            background: linear-gradient(to bottom , #1e9fe0, rgb(160, 231, 245));
            padding: 3px;
            border-radius: 0px 0px 10px 10px;
            box-shadow: 2px 2px 5px 5px rgba(109, 108, 108, 0.2);            
        }
        #main{
            margin-top: 15px;
        }
        #sidebar{
            background-color: #dde3e6;
            padding: 10px;
            border-radius: 15px 15px 15px 15px;
            box-shadow: 2px 2px 5px 5px rgba(109, 108, 108, 0.2);
            height: 100%;
        }
        svg{
            display: block;
            margin: auto;
            width: 100%;
            height: 100%;
            max-width: 250px;
            max-height: 70px;
        }
        #linux{
            max-width: 100px;
            max-height: 100px;
            display: block;
            margin: auto;
        }
        #linux:hover{
            stroke: rgb(255, 255, 255);
            stroke-width: 5px;
            stroke-linecap: round;
            stroke-linejoin: round;
            stroke-dasharray: 5000;
            stroke-dashoffset: 5000;
            animation: light 10s ease-out forwards;
        
        }
        @keyframes light {
            from{
                stroke-dashoffset: 5000;
            }
            
            to{
                stroke-dashoffset: 0;
            }
        }
        .systemfiles, .networkconfiguration, .systemsservices, .systemslogs, .serviceslogs {
            padding: 10px;
        }
        details > div{
            text-align: left !important;
            margin-left: 10px;
        }
        </style>
    </head>
    <body>
        <div class='container text-center' id='header'>
            <h2>Linux's Doctor - $date</h2>
        </div>
        <div class='container' id='main'>
            <div class='row'>
                <div class='col-md-3 col-12 order-md-first order-last' id='sidebar'> <!--sidebar start-->
                    <svg id='linux'  xmlns='http://www.w3.org/2000/svg' viewBox='0 0 304.998 304.998' style='enable-background:new 0 0 304.998 304.998' xml:space='preserve'>
                        <a href='https://github.com/Layraaa/Linuxs-Doctor'>     
                            <path d='M274.659 244.888c-8.944-3.663-12.77-8.524-12.4-15.777.381-8.466-4.422-14.667-6.703-17.117 1.378-5.264 5.405-23.474.004-39.291-5.804-16.93-23.524-42.787-41.808-68.204-7.485-10.438-7.839-21.784-8.248-34.922-.392-12.531-.834-26.735-7.822-42.525C190.084 9.859 174.838 0 155.851 0c-11.295 0-22.889 3.53-31.811 9.684-18.27 12.609-15.855 40.1-14.257 58.291.219 2.491.425 4.844.545 6.853 1.064 17.816.096 27.206-1.17 30.06-.819 1.865-4.851 7.173-9.118 12.793-4.413 5.812-9.416 12.4-13.517 18.539-4.893 7.387-8.843 18.678-12.663 29.597-2.795 7.99-5.435 15.537-8.005 20.047-4.871 8.676-3.659 16.766-2.647 20.505-1.844 1.281-4.508 3.803-6.757 8.557-2.718 5.8-8.233 8.917-19.701 11.122-5.27 1.078-8.904 3.294-10.804 6.586-2.765 4.791-1.259 10.811.115 14.925 2.03 6.048.765 9.876-1.535 16.826-.53 1.604-1.131 3.42-1.74 5.423-.959 3.161-.613 6.035 1.026 8.542 4.331 6.621 16.969 8.956 29.979 10.492 7.768.922 16.27 4.029 24.493 7.035 8.057 2.944 16.388 5.989 23.961 6.913 1.151.145 2.291.218 3.39.218 11.434 0 16.6-7.587 18.238-10.704 4.107-.838 18.272-3.522 32.871-3.882 14.576-.416 28.679 2.462 32.674 3.357 1.256 2.404 4.567 7.895 9.845 10.724 2.901 1.586 6.938 2.495 11.073 2.495h.001c4.416 0 12.817-1.044 19.466-8.039 6.632-7.028 23.202-16 35.302-22.551 2.7-1.462 5.226-2.83 7.441-4.065 6.797-3.768 10.506-9.152 10.175-14.771-.276-4.667-3.365-8.761-8.062-10.684zm-150.47-1.353c-.846-5.96-8.513-11.871-17.392-18.715-7.26-5.597-15.489-11.94-17.756-17.312-4.685-11.082-.992-30.568 5.447-40.602 3.182-5.024 5.781-12.643 8.295-20.011 2.714-7.956 5.521-16.182 8.66-19.783 4.971-5.622 9.565-16.561 10.379-25.182 4.655 4.444 11.876 10.083 18.547 10.083 1.027 0 2.024-.134 2.977-.403 4.564-1.318 11.277-5.197 17.769-8.947 5.597-3.234 12.499-7.222 15.096-7.585 4.453 6.394 30.328 63.655 32.972 82.044 2.092 14.55-.118 26.578-1.229 31.289-.894-.122-1.96-.221-3.08-.221-7.207 0-9.115 3.934-9.612 6.283-1.278 6.103-1.413 25.618-1.427 30.003-2.606 3.311-15.785 18.903-34.706 21.706-7.707 1.12-14.904 1.688-21.39 1.688-5.544 0-9.082-.428-10.551-.651l-9.508-10.879c3.749-1.851 7.497-5.757 6.509-12.805zm12.065-179.386c-.297.128-.589.265-.876.411-.029-.644-.096-1.297-.199-1.952-1.038-5.975-5-10.312-9.419-10.312-.327 0-.656.025-1.017.08-2.629.438-4.691 2.413-5.821 5.213.991-6.144 4.472-10.693 8.602-10.693 4.85 0 8.947 6.536 8.947 14.272 0 .975-.071 1.945-.217 2.981zm37.686 4.607c.444-1.414.684-2.944.684-4.532 0-7.014-4.45-12.509-10.131-12.509-5.552 0-10.069 5.611-10.069 12.509 0 .47.023.941.067 1.411-.294-.113-.581-.223-.861-.329-.639-1.935-.962-3.954-.962-6.015 0-8.387 5.36-15.211 11.95-15.211 6.589 0 11.95 6.824 11.95 15.211 0 3.489-.963 6.819-2.628 9.465zm-4.859 16.324c-.095.424-.297.612-2.531 1.774-1.128.587-2.532 1.318-4.289 2.388l-1.174.711c-4.718 2.86-15.765 9.559-18.764 9.952-2.037.274-3.297-.516-6.13-2.441-.639-.435-1.319-.897-2.044-1.362-5.107-3.351-8.392-7.042-8.763-8.485 1.665-1.287 5.792-4.508 7.905-6.415 4.289-3.988 8.605-6.668 10.741-6.668.113 0 .215.008.321.028 2.51.443 8.701 2.914 13.223 4.718 2.09.834 3.895 1.554 5.165 2.01 4.001 1.374 6.087 3.132 6.34 3.79zm35.947 186.37c2.257-10.181 4.857-24.031 4.436-32.196-.097-1.855-.261-3.874-.42-5.826-.297-3.65-.738-9.075-.283-10.684.09-.042.19-.078.301-.109.019 4.668 1.033 13.979 8.479 17.226 2.219.968 4.755 1.458 7.537 1.458 7.459 0 15.735-3.659 19.125-7.049 1.996-1.996 3.675-4.438 4.851-6.372.257.753.415 1.737.332 3.005-.443 6.885 2.903 16.019 9.271 19.385l.927.487c2.268 1.19 8.292 4.353 8.389 5.853-.001.001-.051.177-.387.489-1.509 1.379-6.82 4.091-11.956 6.714-9.111 4.652-19.438 9.925-24.076 14.803-6.53 6.872-13.916 11.488-18.376 11.488-.537 0-1.026-.068-1.461-.206-4.844-1.51-8.831-8.499-6.689-18.466zM39.917 245.477c-.494-2.312-.884-4.137-.465-5.905.304-1.31 6.771-2.714 9.533-3.313 3.883-.843 7.899-1.714 10.525-3.308 3.551-2.151 5.474-6.118 7.17-9.618 1.228-2.531 2.496-5.148 4.005-6.007.085-.05.215-.108.463-.108 2.827 0 8.759 5.943 12.177 11.262.867 1.341 2.473 4.028 4.331 7.139 5.557 9.298 13.166 22.033 17.14 26.301 3.581 3.837 9.378 11.214 7.952 17.541-1.044 4.909-6.602 8.901-7.913 9.784-.476.108-1.065.163-1.758.163-7.606 0-22.662-6.328-30.751-9.728l-1.197-.503c-4.517-1.894-11.891-3.087-19.022-4.241-5.674-.919-13.444-2.176-14.732-3.312-1.044-1.171.167-4.978 1.235-8.337.769-2.414 1.563-4.91 1.998-7.523.617-4.168-.109-7.561-.691-10.287z'/>
                        </a>
                    </svg>
                    <a href='https://github.com/Layraaa/Linuxs-Doctor'>
                        <h3 class='text-center'>Linux's Doctor</h3>
                    </a>
                    <div class='sidebar-list'>
                        <ul>
                            <li>OS: $os</li>
                            <li>Hostname: $(hostname)</li>
                            <li>Kernel's version: $(uname -r)</li>
                            <li>IP address: $(hostname -I)</li>
                            <li>Linux's Doctor version: v1.2</li>
                            <li>Analysis type: $linuxsdoctor</li>
                        </ul>
                    </div>
                    <h3 class='text-center'>OS supported</h3>
                    <div><svg version='1.0' xmlns='http://www.w3.org/2000/svg' width='484' height='181.333' viewBox='0 0 363 136'><path d='M9.5 25.8c1.1.5 7.2 1.2 13.7 1.6 15.8.8 35.6 4.8 37.2 7.5.3.4-5.1.8-12 .9-11.9.2-40.1 3.5-41.3 4.8-.3.4 1.9.4 4.9 0C28.2 38.5 34.8 38 47.8 38c14.6 0 18.9 1.2 8.1 2.4-3.3.3-10.1 1.9-14.9 3.6-8.7 2.9-23 9.5-23 10.6 0 .3.3.3.8.1 7.7-4.5 22.2-9.4 33.8-11.3 10.4-1.8 10.7-1.7 12.1 3.5.4 1.6.1 2.6-1 3.3-.9.5-2.9 2.9-4.3 5.4-2.2 3.7-2.6 5.3-2.1 9.1 1 8.7 7.5 13.7 20.1 15.3 8.8 1.1 12.1 2.6 18.4 8.3 5.3 4.9 8.7 10.1 11.3 17.1 1.8 4.9 1.9 4.9 1.5 1.3-.7-5.9-5-14.2-10.3-19.8-4.1-4.4-4.4-5.1-2.3-4.4 5.3 1.6 9.9 4.6 13.4 8.6 4.2 5 4.8 4.2.9-1.4C105.6 83 97.6 79.5 80.4 77c-10.2-1.5-15.7-4.1-17.8-8.4-2-4.2-2-5.7-.2-10.1 2.2-5.1 6.9-7.7 13.1-7.2 6.1.6 18.5 5.4 18.5 7.2 0 2 9.1 7.8 10.2 6.7.6-.6.3-1.5-.9-2.3-1-.8-2.4-2.6-3.2-4.2-.8-1.5-2-2.7-2.6-2.7-.7 0-1.8-.7-2.5-1.5S92.9 53 92 53c-1 0-2-.3-2.2-.8-.4-1-9.6-4-15.9-5.2-6.8-1.3-9.9-4.1-9.9-9.1 0-2-.6-4.1-1.3-4.7-2-1.7-15.5-5-24.7-6.1-12.6-1.5-30.9-2.3-28.5-1.3zM292.2 29.2c-6.5 3.2-11.8 8.5-16.3 15.9-4.4 7.3-5.2 11.2-4.7 23.4.4 10.3.7 11.7 4.1 18.9 6.2 13.1 18.4 23.2 29 24.2 3.6.3 3.8.2 1.2-.5-9.6-2.6-24.1-18.1-23.7-25.4 0-.9-1-2.4-2.3-3.3-3.2-2.1-5.1-12.6-3.7-20.4 2.1-11.6 4.8-15.7 13.7-21.4 10.1-6.4 11.5-6.9 19-7 6.4 0 7.8.3 12.1 3 3 1.8 6 4.8 7.9 7.8 2.6 4.3 3 6 3.3 13.6.3 6.9.1 8.9-1.2 9.9-.9.8-1.6 1.9-1.6 2.6 0 1.9-4.3 5.1-9.6 7.1-3.7 1.4-5.1 1.5-8.4.5-8.2-2.5-13.6-12.3-10.6-19.4 2.3-5.6 6.2-7.9 12.4-7.5 4.5.3 5 .1 3.5-1-2.5-1.9-10.8-1-13.4 1.4-5 4.5-7.4 13.7-4.8 18.7.6 1.2 2.8 4 4.8 6.1 3.5 3.7 2.8 4.1-1.4.7l-2-1.6 2 2.4c2 2.4 7.3 5.1 9.7 5.1.7-.1 0-.7-1.7-1.4-2.7-1.1-2.4-1.2 3.6-.8 5.3.3 7.3 0 10.5-1.7 4.8-2.5 8.4-5.6 8.4-7 0-.6.4-1.1.9-1.1s1.4-1.5 2.1-3.3c.7-1.7 1.8-4.5 2.5-6.2.8-1.6 1.2-3.2 1-3.6-.3-.3-.7-2.5-1-4.9-.3-2.4-1-4.9-1.6-5.7-.9-1-.8-1.3.4-1.3.8 0 1.8.6 2 1.2.3.7.6.2.6-1.2.1-3.1-6.3-11.6-10.4-13.9-1.6-.9-3.1-1.9-3.3-2.4-.2-.4-1.4-.7-2.7-.7-1.3 0-3.6-.5-5-1-1.5-.6-6.4-1.3-10.9-1.5-7.6-.5-8.5-.3-14.4 2.7zM170.9 33.9c-11.9 3.8-20.3 12.3-24 24.5-5.3 16.8 2.7 34.8 18.9 42.8 6 3 7.5 3.3 15.7 3.3 7.7 0 9.8-.4 14.7-2.7 7.9-3.7 14.2-9.8 18.1-17.7 2.9-5.9 3.2-7.4 3.2-15.6 0-7.6-.4-9.8-2.6-14.6-8.1-17.2-26.5-25.6-44-20zm25.9 9.7c1.2.8 2.2 2.2 2.2 3.1 0 2.1-2.9 5.3-4.8 5.3-2.2 0-5.2-3-5.2-5.1 0-1.6 3.4-4.9 5-4.9.3 0 1.6.7 2.8 1.6zm-7.8 7.6c1.4 1.9 3.1 2.8 4.9 2.8 3.5 0 5.9 2.6 7.6 8.4l1.4 4.6h-3.5c-3.1 0-3.6-.4-5-4-2.2-5.5-7.2-8.4-14.1-8.3-4.8.1-5.5-.1-6.5-2.3-1.4-3-.9-3.5 3.9-4.4 5.4-.9 8.8.1 11.3 3.2zm-16 5.4c0 .6-.9 1.9-2 2.9-4.5 4.1-4.5 12.2 0 18.5 2 2.8 2 3.1.4 5.5l-1.7 2.6-3-2.8c-4.6-4.4-5.8-8-3.9-11.9 1.4-3 1.4-3.5-.2-5.8-1.5-2.4-1.5-2.8 0-5.9.9-1.7 2.8-4.5 4.2-6l2.6-2.8 1.8 2.3c1 1.3 1.8 2.8 1.8 3.4zm-12.6 9c3 2.9 1 7.4-3.2 7.4-3.3 0-5.2-1.6-5.2-4.5 0-4.3 5.3-6.1 8.4-2.9zm41.6 8.1c-1.2 5.2-4.1 8.6-8.1 9.4-1.8.4-4.3 1.9-5.4 3.2-1.1 1.4-3.2 2.8-4.6 3.2-3.3.8-10.9-1.2-10.9-2.8.1-3 2.6-4.3 8-4.3 7.8 0 12-3.1 14.4-10.7.4-1.2 1.6-1.7 4-1.7h3.4l-.8 3.7zm-4.8 13c2.2 2 2.3 4.1.1 6.5-2 2.2-4.1 2.3-6.5.1-2.2-2-2.3-4.1-.1-6.5 2-2.2 4.1-2.3 6.5-.1zM88 47.7c1.3 1 3.9 3.1 5.7 4.7 1.8 1.5 3.3 2.3 3.3 1.8 0-.6-1.9-2.4-4.2-4-4.9-3.3-8.5-5.2-4.8-2.5z'/></svg></div>
                    <div>
                        <svg version='1.0' xmlns='http://www.w3.org/2000/svg'
                        width='136.000000pt' height='136.000000pt' viewBox='0 0 136.000000 136.000000'
                        preserveAspectRatio='xMidYMid meet'>
                            <g transform='translate(0.000000,136.000000) scale(0.100000,-0.100000)'
                            fill='#000000' stroke='none'>
                                <path d='M580 1235 l-95 -95 -132 0 -133 0 0 -132 0 -133 -97 -97 -98 -98 98
                                -98 97 -97 0 -133 0 -132 132 0 133 0 97 -97 98 -98 98 98 97 97 133 0 132 0
                                0 132 0 133 97 97 98 98 -98 98 -97 97 0 133 0 132 -133 0 -132 0 -95 95 c-52
                                52 -97 95 -100 95 -3 0 -48 -43 -100 -95z m145 -55 l39 -40 -32 6 -32 7 0
                                -151 c0 -164 -4 -189 -26 -171 -11 9 -14 47 -14 166 l0 155 -25 -4 c-14 -3
                                -25 -4 -25 -2 0 4 65 71 70 73 3 0 24 -17 45 -39z m-339 -138 c-15 -18 -11
                                -24 89 -122 100 -99 126 -140 88 -140 -9 0 -64 47 -122 105 -99 99 -106 104
                                -123 88 -17 -15 -18 -14 -18 35 l0 52 52 0 c49 0 50 -1 34 -18z m194 -49 l0
                                -67 -49 48 -50 49 22 18 c12 10 34 18 50 19 27 0 27 0 27 -67z m283 49 c16
                                -17 14 -21 -31 -65 l-47 -46 0 64 0 65 31 0 c17 0 38 -8 47 -18z m197 -34 c0
                                -49 -1 -50 -18 -35 -17 15 -24 10 -122 -88 -58 -58 -113 -105 -122 -105 -39 0
                                -14 41 87 140 100 98 104 104 89 122 -16 17 -15 18 34 18 l52 0 0 -52z m-670
                                -183 l44 -45 -67 0 c-66 0 -67 0 -67 27 0 24 24 63 39 63 4 0 27 -20 51 -45z
                                m659 32 c6 -8 14 -28 17 -45 l7 -32 -74 0 -73 0 44 45 c47 48 61 53 79 32z
                                m133 -219 l-42 -43 0 32 0 32 -152 3 c-128 3 -153 5 -153 18 0 13 25 15 153
                                18 l152 3 0 32 0 32 42 -43 43 -42 -43 -42z m-970 87 l-4 -24 158 -3 c133 -3
                                159 -5 159 -18 0 -13 -26 -15 -159 -18 l-158 -3 6 -32 6 -32 -41 41 -41 42 38
                                36 c22 19 40 36 40 36 1 0 -1 -11 -4 -25z m488 -12 c0 -7 8 -13 18 -13 14 0
                                15 -2 2 -10 -13 -9 -13 -11 0 -20 13 -8 12 -10 -2 -10 -10 0 -18 -6 -18 -13 0
                                -7 -9 -13 -20 -13 -11 0 -20 6 -20 13 0 7 -8 13 -17 13 -15 0 -16 2 -3 10 13
                                9 13 11 0 20 -13 8 -12 10 3 10 9 0 17 6 17 13 0 7 9 13 20 13 11 0 20 -6 20
                                -13z m-317 -185 c-44 -45 -48 -47 -65 -31 -10 9 -18 30 -18 47 l0 31 65 0 64
                                0 -46 -47z m197 34 c0 -10 -47 -65 -105 -122 -58 -56 -105 -105 -105 -108 0
                                -3 8 -11 18 -18 15 -12 10 -13 -35 -14 l-53 0 0 52 c0 51 0 51 20 33 21 -19
                                22 -18 128 88 106 106 132 124 132 89z m339 -87 c95 -95 106 -103 121 -90 27
                                24 31 18 28 -37 l-3 -53 -52 -3 c-56 -3 -62 1 -38 28 14 15 6 26 -90 120 -100
                                99 -126 140 -88 140 9 0 64 -47 122 -105z m151 77 c0 -17 -10 -37 -23 -50
                                l-23 -22 -49 50 -49 50 72 0 72 0 0 -28z m-372 -185 l3 -157 27 0 27 0 -38
                                -37 -37 -38 -37 38 -38 37 28 0 27 0 0 153 c0 85 3 157 7 161 22 21 28 -11 31
                                -157z m-118 -2 l0 -65 -32 0 c-17 0 -40 8 -50 17 -18 16 -17 18 29 65 26 26
                                49 48 50 48 2 0 3 -29 3 -65z m275 -52 c-14 -13 -37 -23 -51 -23 -23 0 -24 2
                                -24 72 l0 72 50 -49 51 -50 -26 -22z'/>
                            </g>
                        </svg>
                    </div>
                    <div class='text-center'>
                        <p>⚒️Made by <a href='https://github.com/Layraaa'>Layraaa</a> and <a href='https://github.com/Japinper'>Japinper</a>⚒️</p>
                    </div>
                </div> <!--sidebar end-->
                <div class='col-md-9 col-12'> <!--Start info block-->
    " >> "$datapath"/report-"$date".html

    while read -r line # While X where X is the number of categories selected
    do
        count=$(("$y" * 3))
        {
            echo "
                    <div class='row text-center ${varsname[y]}'>
                        <div class='col-12'>
                            <h3>$line</h3>
                        </div>"
            temp="unmodified${varsname[y]}"
            echo "            
                        <div class='col-4'>
                            <details>
                            <summary class='true'>Unmodified files: ${!temp}</summary>"

            echo "${var[0 + count]}" > /lib/linuxsdoctor/tempcomparisions.txt
            sed -i '/^$/d' /lib/linuxsdoctor/tempcomparisions.txt
            while read -r linecomparisions
            do
                echo "                            <div>$linecomparisions</div>"
            done </lib/linuxsdoctor/tempcomparisions.txt
            
            echo "                        </details>
                        </div>"
            temp="modified${varsname[y]}"
            echo "
                        <div class='col-4'>
                            <details>
                            <summary class='False'>Modified files: ${!temp}</summary>"

            echo "${var[2 + count]}" > /lib/linuxsdoctor/tempcomparisions.txt
            sed -i '/^$/d' /lib/linuxsdoctor/tempcomparisions.txt
            while read -r linecomparisions
            do
                echo "                            <div>$linecomparisions</div>"
            done </lib/linuxsdoctor/tempcomparisions.txt

            echo "                        </details>
                        </div>"
            temp="errors${varsname[y]}"
            echo "
                        <div class='col-4'>
                            <details>
                                <summary class='errors'>Errors finded: ${!temp}</summary>"

            echo "${var[1 + count]}" > /lib/linuxsdoctor/tempcomparisions.txt
            sed -i '/^$/d' /lib/linuxsdoctor/tempcomparisions.txt
            while read -r linecomparisions
            do
                echo "                            <div>$linecomparisions</div>"
            done </lib/linuxsdoctor/tempcomparisions.txt

            echo "                         </details>
                        </div>
                    </div>"
        } >> "$datapath"/report-"$date".html
        ((y++))

    done </lib/linuxsdoctor/temp.txt

    # Wrire end of file and CDNs
    echo "                <br>
                    </div>
                </div> <!--End block-->
            </div> <!--End row-->
        </div>
    </body>
    <!--CDN-->
    <script src='https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/js/bootstrap.bundle.min.js' integrity='sha384-A3rJD856KowSb7dwlZdYEkO39Gagi7vIsF0jrRAoQmDKKtQBHUuLZ9AsSv4jD4Xa' crossorigin='anonymous'></script>
    <script src='https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.5/dist/umd/popper.min.js' integrity='sha384-Xe+8cL9oJa6tN/veChSP7q+mnSPaj5Bcu9mPX5F5xIGE0DVittaqT5lorf0EI7Vk' crossorigin='anonymous'></script>
    <script src='https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/js/bootstrap.min.js' integrity='sha384-ODmDIVzN+pFdexxHEHFBQH3/9/vQ9uori45z4JjnFsRydbmQbmL5t1tQ0culUzyK' crossorigin='anonymous'></script>
    <!--CDN-->
    </html>" >> "$datapath"/report-"$date".html

    # Erase empty lines and [*], [!], [?]
    sed -i '/^$/d' "$datapath"/report-"$date".html
    sed -i 's/<div>\[.\]/<div>-/' "$datapath"/report-"$date".html

    # Remove temporal files
    rm -rf /lib/linuxsdoctor/temp.txt /lib/linuxsdoctor/tempcomparisions.txt

}