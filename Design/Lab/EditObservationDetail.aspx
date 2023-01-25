<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditObservationDetail.aspx.cs"
    Inherits="Design_Lab_EditObservationDetail" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
     <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" />
    <script  src="../../Scripts/jquery-1.4.2.min.js" type="text/javascript"></script>
    <script  src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
     <script  src="../../Scripts/jquery.tablednd.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Common.js"> </script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript">

        var ObsDetail = "";
        var ObsId = '';
        var InvId = '';
        $(document).ready(function () {
            $(':text').bind('keyup blur', function () {
                if (this.value != '' && this.value.match(/[\"|\']/g)) {
                    this.value = this.value.replace(/[\"|\']/g, '');
                }
            });
            var maxLength = 10;
            $("#txtToAge").keyup(function () {
                var text = $(this).val();
                var textLength = text.length;
                if (textLength > maxLength) {
                    $(this).val(text.substring(0, (maxLength)));
                }
            });
            ObsId = '<%=ObsId %>';
            InvId = '<%=InvId%>';
            SelectGen(InvId);
            GetObsMasterData(ObsId);
            $('#<%=rblGender.ClientID%>').click(function () {
                GetObservationDetails(InvId, ObsId);
            });
            $('#<%=ddlMachine.ClientID%>').change(function () {
                GetObservationDetails(InvId, ObsId);
            });
            $('#<%=ddlCentre.ClientID%>').change(function () {
                GetObservationDetails(InvId, ObsId);
            });
        });
        function SelectGen(InvId) {
            $.ajax({
                url: "../Lab/Services/MapInvestigationObservation.asmx/SelectGender",
                data: '{InvestigationID: "' + InvId + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = result.d;
                    if (data == "M") {
                        $('#<%=rblGender.ClientID %> :radio[value="M"]').attr('checked', 'checked');
                        $('#<%=rblGender.ClientID %> :radio[value="F"]').attr("disabled", "disabled");

                    }
                    else if (data == "F") {
                        $('#<%=rblGender.ClientID %> :radio[value="F"]').attr('checked', 'checked');
                        $('#<%=rblGender.ClientID %> :radio[value="M"]').attr("disabled", "disabled");

                    }
                    else {
                        $('#<%=rblGender.ClientID %> :radio[value="M"]').attr('checked', 'checked');
                        $('#<%=rblGender.ClientID %> input:radio').removeAttr("disabled");
                    }
                    GetObservationDetails(InvId, ObsId);
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
    }

    function GetObsMasterData(ObsId) {
        $.ajax({
            url: "../Lab/Services/MapInvestigationObservation.asmx/GetObsMasterData",
            data: '{ObservationID: "' + ObsId + '"}', // parameter map
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                ObsMasterData = jQuery.parseJSON(result.d);
                $('#txtObservation').val(ObsMasterData[0].Name);
                $('#txtSuffix').val(ObsMasterData[0].Suffix);
                if (ObsMasterData[0].Culture_flag == '1')
                    $('#chkIsCulture').attr('checked', true)
                else
                    $('#chkIsCulture').attr('checked', false)
            },
            error: function (xhr, status) {
                alert(xhr.responseText);
                window.status = status + "\r\n" + xhr.responseText;
            }
        });
    }
    function GetObservationDetails(InvId, ObsId) {

        var Gender = $('#<%=rblGender.ClientID%> :checked').val();
        var MachineID = $('#<%=ddlMachine.ClientID%>').val();
        var CentreID = $('#<%=ddlCentre.ClientID%>').val();
        if (Gender == "B") {
           //  alert("In case of Both, Default Male ranges are loaded \r\n You can save these ranges for Both Male and female also !");
             modelAlert("In case of Both, Default Male ranges are loaded \r\n You can save these ranges for Both Male and female also !");
            Gender = "M";
        }

        $.ajax({
            url: "../Lab/Services/MapInvestigationObservation.asmx/GetObservationDetails",
            data: '{ ObservationID: "' + ObsId + '",InvestigationID: "' + InvId + '",Gender:"' + Gender + '",MachineID:"' + MachineID + '",CentreID:"' + CentreID + '"}', // parameter map
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                ObsDetail = jQuery.parseJSON(result.d);
                var output = $('#tb_InvestigationItems').parseTemplate(ObsDetail);
                $('#div_InvestigationItems').html(output);
                $("#tb_grdLabSearch tr").find("#imgAdd,#imgRmv").hide();
                $("#tb_grdLabSearch tr:last").find("#imgAdd,#imgRmv").show();
                tableproperties();
                if (ObsDetail.length == "0") {
                    AddnewRow('1', '0');
                    $('#txtconversionfactor').val('');
                    $('#txtunit').val('');
                }
                else {
                    $('#txtconversionfactor').val(ObsDetail[0].ConversionFactor);
                    $('#txtunit').val(ObsDetail[0].ConversionFactorUnit);
                }
            },
            error: function (xhr, status) {
                alert(xhr.responseText);
                window.status = status + "\r\n" + xhr.responseText;
            }
        });
    };
    </script>
    <script type="text/javascript">
        function tableproperties() {
            $("#tb_grdLabSearch tr").find("#txtToAge,#txtMinCritical,#txtMaxCritical").bind('keyup blur ', function () {
                this.value = this.value.replace(/[^0-9,-,.]/g, '');

            });
            //            $("#tb_grdLabSearch tr").find("#txtToAge,#txtMinReading,#txtMaxReading,#txtMinCritical,#txtMaxCritical").bind('keyup blur ', function (e) {
            //                var c = e.keyCode;
            //                value = $(this).val();
            //                alert(value.indexOf('.'));
            //                alert(c);
            //                // Prevent insertion if the inserting character is
            //                // 1. a 'dot' but there is already one in the text box, or
            //                // 2. not numerics.
            //                if ((c == 190 && value.indexOf('.') < -1) || c < 48 || c > 57) {
            //                    e.preventDefault();
            //                    return;
            //                }
            //            });
            $("#tb_grdLabSearch tr").find("#txtToAge,#txtMinCritical,#txtMaxCritical,#txtReadingFormat").bind('keypress keyup keydown  ', function () {

                while (($(this).val().split(".").length - 1) > 2) {

                    $(this).val($(this).val().slice(0, -2));

                    if (($(this).val().split(".").length - 2) > 1) {
                        continue;
                    } else {
                        return false;
                    }
                }
            });

            $("#tb_grdLabSearch tr").find(':text').bind('keyup blur ', function () {
                this.value = this.value.replace(/[\"|\']/g, '');
            });

            $("#tb_grdLabSearch tr").find("#txtMaxReading").blur(function () {
                if (Number(this.value) <= $(this).closest("tr").find("#txtMinReading").val())
                    this.value = '';
            });

            $("#tb_grdLabSearch tr").find("#txtMaxCritical").blur(function () {
                if (Number(this.value) <= $(this).closest("tr").find("#txtMinCritical").val())
                    this.value = '';
            });
            var maxLength = 6;
            $("#tb_grdLabSearch tr").find("#txtToAge,#txtMinCritical,#txtMaxCritical").bind('keypress keyup blur', function () {
                if ((this.value.length) > maxLength) {
                    $(this).val($(this).val().substr(0, this.value.length - 1));
                    return false;
                }
            });
            var maxLength1 = 50;
            $("#tb_grdLabSearch tr").find("#txtReadingFormat").bind('keyup blur keypress', function () {
                if ((this.value.length) > maxLength1) {
                    $(this).val($(this).val().substr(0, this.value.length - 1));
                    return false;
                }
            });
        }
        function AddDetail() {
            var count = $("#tb_grdLabSearch tr").length;
            var ToAge = $("#tb_grdLabSearch").find('#tr_' + (count - 1)).find('td:eq(' + 3 + ')').find("#txtToAge").val();
            var frmAge = $("#tb_grdLabSearch").find('#tr_' + (count - 1)).find('td:eq(' + 1 + ')').find("#lblFromAge").text();
            if (ToAge == "") {
                modelAlert('Please Enter Age');
               // alert('Please Enter Age');
                $("#tb_grdLabSearch").find('#tr_' + (count - 1)).find('td:eq(' + 3 + ')').find("#txtToAge").focus();
                return;
            }
            var isVisible = $("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#txtToAge").is(':visible');
            if (isVisible == true && (Number(ToAge) < Number(frmAge))) {
                modelAlert('To Age Should be Greater than FromAge');
                // alert('To Age Should be Greater than FromAge');
                return;
            }
            if (ToAge > 58400) {
                modelAlert('Age Cannot Be Greater Than 180 Yrs');
             //   alert('Age Cannot Be Greater Than 180 Yrs');
                return;
            }
            if ($("#tb_grdLabSearch tr:last").find('td:eq(' + 4 + ')').find("#txtMinReading").val() == "") {
                modelAlert('Please Enter Min. Reading');
              //  alert('Please Enter Min. Reading');
                $("#tb_grdLabSearch tr:last").find('td:eq(' + 4 + ')').find("#txtMinReading").focus();
                return;
            }
            if ($("#tb_grdLabSearch tr:last").find('td:eq(' + 5 + ')').find("#txtMaxReading").val() == "") {
                modelAlert('Please Enter Max. Reading');
               // alert('Please Enter Max. Reading');
                $("#tb_grdLabSearch tr:last").find('td:eq(' + 5 + ')').find("#txtMaxReading").focus();
                return;
            }
            if ($("#tb_grdLabSearch tr:last").find('td:eq(' + 4 + ')').find("#txtMinReading").val() != "" && $("#tb_grdLabSearch tr:last").find('td:eq(' + 5 + ')').find("#txtMaxReading").val()) {
                if (Number($("#tb_grdLabSearch tr:last").find('td:eq(' + 4 + ')').find("#txtMinReading").val()) >= Number($("#tb_grdLabSearch tr:last").find('td:eq(' + 5 + ')').find("#txtMaxReading").val())) {
                    modelAlert('Max Range Should be Greater than MinAge');
                //    alert('Max Range Should be Greater than MinAge');
                    $("#tb_grdLabSearch tr:last").find('td:eq(' + 5 + ')').find("#txtMaxReading").focus();
                    return;
                }
            }
            $("#tb_grdLabSearch tr:last").find("#imgAdd,#imgRmv").hide();
            $("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#lblToAge").show();
            $("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#lblToAge").text(ToAge);
            $("#tb_grdLabSearch tr:last").find('td:eq(' + 2 + ')').find("#txtToAgeyears").attr('disabled', 'disabled');
            $("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#txtToAge").hide();
            var frmAgenew = $("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#lblToAge").text();
            frmAgenew = Number(frmAgenew) + 1;
            AddnewRow(count, frmAgenew);
        }
        function AddnewRow(count, frmAgenew) {
            var newRow = $('<tr />').attr('id', 'tr_' + count);
            newRow.html('<td class="GridViewLabItemStyle">' + count + '</td><td class="GridViewLabItemStyle"><span id="lblFromAge" >' + frmAgenew + '</span></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtToAgeyears" type="text" style="width: 50px" autocomplete="off" onkeyup="CalculateAgeOnDays(this)" onlynumber="3" decimalplace="2" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" max-value="180" /></td> ' +
                '<td class="GridViewLabItemStyle"><span id="lblToAge" /><input id="txtToAge" type="text" style="width: 50px" autocomplete="off"  /></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtMinReading" type="text" style="width: 50px" autocomplete="off"   /></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtMaxReading" type="text" style="width: 50px" autocomplete="off"   /></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtMinCritical" type="text" style="width: 50px" autocomplete="off"   /></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtMaxCritical" type="text" style="width: 50px" autocomplete="off"   /></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtReadingFormat" type="text" style="width: 50px" autocomplete="off"   /></td> ' +
                '<td class="GridViewLabItemStyle"><textarea id="txtDisplayReading" type="text" style="width: 300px" autocomplete="off" ></textarea></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtDefaultReading" style="width: 60px" autocomplete="off"   /></td> ' +
                '<td id="imgAdd" class="GridViewLabItemStyle"><img src="../../Images/ButtonAdd.png" onclick="AddDetail()" /></td> ' +
                '<td id="imgRmv" class="GridViewLabItemStyle"><img src="../../Images/Delete.gif" onclick="RmvDetail()" /></td>');
            $("#tb_grdLabSearch").append(newRow);
            tableproperties();
        }
        function RmvDetail() {
            $("#tb_grdLabSearch tr:last").remove();
            $("#tb_grdLabSearch tr:last").find("#imgAdd,#imgRmv").show();
            $("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#txtToAge").show();
            $("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#lblToAge").hide();
        }
    </script>
    <script type="text/javascript">
        function SaveObsRanges() {
            var count = $("#tb_grdLabSearch tr").length;
            var a = $("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#txtToAge").val();
            var b = $("#tb_grdLabSearch").find('#tr_' + (count - 1)).find('td:eq(' + 1 + ')').find("#lblFromAge").text();
            //  if (a > 58400) {
            // alert('Age Cannot Be Greater Than 160 Yrs');
            // return;
            // }
            if (Number(a) < Number(b)) {
             //   alert('To Age Should be Greater than FromAge');
                modelAlert('To Age Should be Greater than FromAge');
                return;
            }
            var ObsRanges = "";
            var fromAge = $("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#txtToAge").val();
            if (fromAge == "") {
             //   alert('Age Cannot Be Blank')
                modelAlert('Age Cannot Be Blank');
                return;
            }
            if ($("#txtSuffix").val().length > 1) {
                modelAlert('Suffix Lenght Cannot Be More Then 1');
              //  alert("Suffix Lenght Cannot Be More Then 1");
                return;
            }
            $("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#txtToAge").hide();
            $("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#lblToAge").text(fromAge);


            $("#tb_grdLabSearch tr").each(function () {
                if ($(this).closest("tr").attr("id") != "") {
                    var $rowid = $(this).closest("tr");
                    ObsRanges += $rowid.find("#lblFromAge").text() + '|' + $rowid.find("#lblToAge").text() + '|' + $rowid.find("#txtMinReading").val() + '|' + $rowid.find("#txtMaxReading").val() + '|' + $rowid.find("#txtMinCritical").val() + '|' + $rowid.find("#txtMaxCritical").val() + '|' + $rowid.find("#txtReadingFormat").val() + '|' + $rowid.find("#txtDisplayReading").val() + '|' + $rowid.find("#txtDefaultReading").val() + '|' + $('#txtconversionfactor').val() + '|' + $('#txtunit').val() + '#';
                }
            });
            $.ajax({
                url: "../Lab/Services/MapInvestigationObservation.asmx/ObservationExists",
                data: '{ ObservationName: "' + $('#txtObservation').val() + '", ObservationID: "' + ObsId + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        modelAlert('Observation Already Exist');
                        // alert('Observation Already Exist');
                        SaveRanges(ObsRanges);
                        return;
                    }
                    else if (result.d == "0") {
                        SaveRanges(ObsRanges);
                    }
                    else {
                        SaveRanges(ObsRanges);
                    }

                },
                error: function (xhr, status) {
                    alert("Error ");
                    $('input').attr('disabled', false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }

        function SaveRanges(ObsRanges) {

            var Gender = $('#<%=rblGender.ClientID%> :checked').val();

            if (Gender == "B") {
                var Genderval = "M,F";
                Gender = Genderval.split(',');
            }

            var MachineID = $('#<%=ddlMachine.ClientID%>').val();


            for (var i = 0; i < Gender.length; i++) {

                $('input').attr('disabled', true);
                var IsCulture = '0';
                if ($('#chkIsCulture').attr('checked'))
                    IsCulture = '1';

                var dataobservation = {
                    ObservationName: $('#txtObservation').val(),
                    ObservationID: ObsId,
                    InvestigationID: InvId,
                    ObsRangeData: ObsRanges,
                    Gender: Gender[i],
                    Suffix: $('#txtSuffix').val(),
                    IsCulture: IsCulture,
                    MachineID: MachineID,
                    CentreID: $('#ddlCentre').val(),
                    AllCentre: $('#chkAllCentre').is(':checked') ? "1" : "0"
                }
                $.ajax({
                    url: "../Lab/Services/MapInvestigationObservation.asmx/updtObsRanges",
                    data: JSON.stringify(dataobservation), // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        var data = result.d;
                        if (data == "1") {
                            //alert('Record Saved Successfully');
                            modelAlert('Record Saved Successfully');
                            $("#tb_grdLabSearch tr").remove();
                            $('input').attr('disabled', false);
                            window.close();
                        }
                        if (data == "0") {
                            //  alert('Record Not saved');
                            modelAlert('Record Not saved');
                            $('input').attr('disabled', false);
                        }
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        $('input').attr('disabled', false);
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });

            }
        }
    </script>
    <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;width:100%;">
		<tr >
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">From Age(Days)</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">To Age(Years)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">To Age(Days)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Min. Reading</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Max. Reading </th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Min. Critical</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Max. Critical </th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Reading Format</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Display Reading</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Default Reading </th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Add</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Remove</th>				
</tr>
       <#     
              var dataLength=ObsDetail.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = ObsDetail[j];
        
         
            #>
                    <tr id="tr_<#=j+1#>"  >
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="width:50px;"><span id="lblFromAge" ><#=objRow.FromAge#></span></td>
<td class="GridViewLabItemStyle"><input id="txtToAgeyears" type="text" style="width: 50px" value="<#=objRow.ToAgeyears#>" autocomplete="off" onkeyup="CalculateAgeOnDays(this)" onlynumber="3" decimalplace="2" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" max-value="180" 
    <#
								 if(objRow.ToAge != ''){#>
									 disabled="disabled" <#} 
								  #> 
    /></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtToAge"  style="width:50px; display:none;" type="text" value="<#=objRow.ToAge#>" maxlength="5" size="6" autocomplete="off" /><span id="lblToAge" ><#=objRow.ToAge#></span></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtMinReading"  style="width:50px;" type="text" value="<#=objRow.MinReading#>" maxlength="20" size="7" autocomplete="off"  /></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtMaxReading"   style="width:50px;" type="text" value="<#=objRow.MaxReading#>" maxLength="20" size="7" autocomplete="off" /></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtMinCritical"  style="width:50px;" type="text" value="<#=objRow.MinCritical#>" maxLength="6" autocomplete="off" /></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtMaxCritical"  style="width:50px;" type="text" value="<#=objRow.MaxCritical#>" maxLength="6" autocomplete="off" /></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtReadingFormat"  style="width:50px;" type="text" value="<#=objRow.ReadingFormat#>" maxLength="100" autocomplete="off" /></td>
<td class="GridViewLabItemStyle" style="width:50px;"><textarea id="txtDisplayReading" rows="1"  style="width:300px;" type="text"  autocomplete="off"><#=objRow.DisplayReading#></textarea></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtDefaultReading"  style="width:50px;" value="<#=objRow.DefaultReading#>" maxLength="200"  autocomplete="off" /></td>

<td id="imgAdd" class="GridViewLabItemStyle" style="width:50px;"><img src="../../Images/ButtonAdd.png" onclick="AddDetail();" /></td>
<td id="imgRmv" class="GridViewLabItemStyle" style="width:20px;"><img src="../../Images/Delete.gif" onclick="RmvDetail();" /></td>


 <#}#>
 
</tr>

            

     </table>  
    </script>
    <style type="text/css">
        #btnSave {
            height: 26px;
          background-color: #018eff;
          color:white;
        }

        .auto-style1 {
            width: 159px;
        }

        .auto-style2 {
            width: 68px;
        }
    </style>
  
</head>
<body style="padding: 0px 0px 0px 0px;background-color:white;" >
    <form id="form1" runat="server">
    <Ajax:ScriptManager ID="sm1" runat="server" />
    <div id="POuter_Box_Inventory" style="text-align: center; width: 1160px;">
        <div class="" style="width: 1156px">
             <div class="row"><b>Edit Observation Detail</b></div>
            <div class="row">
		           <asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Horizontal">
                     <asp:ListItem Selected="True" Value="M">Male</asp:ListItem>
                    <asp:ListItem Value="F">Female</asp:ListItem>
                    <asp:ListItem Value="B">BOTH</asp:ListItem>
                </asp:RadioButtonList>
	          </div> 
               
        </div>
        <div class="" style="width: 1156px;">
            <div class="Purchaseheader">
                Observation Details</div>
           <div class="row">
                <div class="col-md">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Observation Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <input id="txtObservation" type="text" style="width: 202px"  maxlength="50"/>
                           <input id="chkIsCulture" type="checkbox" style="display: none;" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Suffix  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input id="txtSuffix" type="text" style="width: 203px" maxlength="6"/>
                        </div> 
                    </div>
                </div> 
            </div>
            <div class="row">
                <div class="col-md">
                    <div class="row">
                         <div class="col-md-4">
                            <label class="pull-left"> Conversion Factor  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtconversionfactor" maxlength="10" style="width:203px" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Unit  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtunit" style="width:203px"  />
                        </div>
                    </div>
                </div>
            </div>
              <div class="row">
                <div class="col-md">
                    <div class="row">
                         <div class="col-md-4">
                            <label class="pull-left">Machine Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:DropDownList ID="ddlMachine" runat="server" ClientIDMode="Static" Width="205px"></asp:DropDownList>
                        </div>
                           <div class="col-md-4">
                            <label class="pull-left">Centre Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:DropDownList ID="ddlCentre" runat="server"  Width="204px" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3"> For All Centre<input id="chkAllCentre" type="checkbox" /></div>
                        </div>
                    </div>
                  </div>
            <br />
        </div>
        <div class="POuter_Box_Inventory" style="width: 1156px;">
            <div class="Purchaseheader">
                Observation Ranges</div>
            <div id="div_InvestigationItems" style="max-height: 600px; width:100%; overflow-y: auto; overflow-x: auto;
                text-align: center;">
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1156px;text-align:center">
                <input id="btnSave" type="button" value="Save Ranges" onclick="SaveObsRanges()" class="ItDoseButton"/>
            <div style="display:none">
                <table>
                    <tr>
                        <td class="auto-style1" style="text-align:right">
                            Enter Years :&nbsp;
                        </td>
                        <td>
                            <input id="txtyears"  style="width:50px;" type="text" maxlength="5" size="6" onkeyup="CalculateDays()" />
                        </td>
                         <td class="auto-style2">
                            <span id="Span1">Days :&nbsp;</span>
                        </td>
                        <td class="auto-style2" style="text-align:left">
                            <span id="spndays"></span>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function CalculateDays() {
            if ($('#txtyears').val() > 0) {
                var Days = (($('#txtyears').val()) * 365);
                $('#spndays').text(Days);
            }
            else
                $('#spndays').text(' ');
        }
        function CalculateAgeOnDays(el) {
            debugger;
            //if ($(el).closest('tr').find("#lblToAge").text() == "") {
            if ($(el).closest('tr').find('#txtToAgeyears').val() != "") {
                var Days = ($(el).closest('tr').find('#txtToAgeyears').val() * 365);
                //alert(Days);
                $(el).closest("tr").find("#txtToAge").val(Days);
            }
            else
                $(el).closest("tr").find("#txtToAge").val('');
            // }
        }

    </script>
    </form>
</body>
</html>
