 <%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Set_MedicalSet_DoctorWise.aspx.cs" Inherits="Design_CPOE_Set_MedicalSet_DoctorWise" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
     <script type="text/javascript">
        function loadSets() {
            jQuery("#ddlSelectSet option").remove();
            $.ajax({
                url: "Set_MedicalSet_DoctorWise.aspx/loadSets",
                data: '{}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != null || data != "") {
                        jQuery("#ddlSelectSet").append(jQuery("<option></option>").val('0').html("--Select--"));
                        for (var i = 0; i < data.length; i++) {
                            $('#ddlSelectSet').append($("<option></option>").val(data[i].ID).html(data[i].Setname));
                        }
                    }
                }
            });
        }
        function BindDoctor() {
            jQuery("#ddlDoctor option").remove();
            $.ajax({
                url: "Set_MedicalSet_DoctorWise.aspx/BindDoctor",
                data: '{}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != null || data != "") {
                        jQuery("#ddlDoctor").append(jQuery("<option></option>").val('0').html("--Select--"));
                        for (var i = 0; i < data.length; i++) {
                            $('#ddlDoctor').append($("<option></option>").val(data[i].DoctorID).html(data[i].Name));
                        }
                    }
                }
            });
        }
        function LoadSetItems() {
            $.ajax({
                type: "POST",
                data: '{SetID:"' + $('#ddlSelectSet').val() + '"}',
                url: "Set_MedicalSet_DoctorWise.aspx/LoadSetItems",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);
                    if (PatientData != null) {
                        var output = $('#tb_PatientMedicineSearch').parseTemplate(PatientData);
                        $('#PatientMedicineSearchOutput').html(output);
                        $('#PatientMedicineSearchOutput').show();
                    }
                    else {
                        $('#PatientMedicineSearchOutput').html();
                        $('#PatientMedicineSearchOutput').hide();
                       
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#debugArea").html("");
                    $("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        function LoadMapSet() {
            $.ajax({
                type: "POST",
                data: '{DoctorID:"' + $('#ddlDoctor').val() + '"}',
                url: "Set_MedicalSet_DoctorWise.aspx/BindMapSet",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data != null) {
                        var output = $('#tb_MapSet').parseTemplate(Data);
                        $('#divMapping').html(output);
                        $('#divMapping').show();
                    }
                    else {
                        $('#divMapping').html();
                        $('#divMapping').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#debugArea").html("");
                    $("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        $(document).ready(function () {
            loadSets();
            BindDoctor();
            $('.searchable').chosen({ width: '100%' });
        });

       
        function MapSet() {
            if ($("#ddlDoctor").val() != "0") {
                if ($("#ddlSelectSet").val() != "0") {
                    $.ajax({
                        url: "Set_MedicalSet_DoctorWise.aspx/MapSet",
                        data: '{DoctorID:"' + $("#ddlDoctor").val() + '",SetID:"' + $("#ddlSelectSet").val() + '"}', // parameter map
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        async: false,
                        dataType: "json",
                        success: function (result) {
                            Data = (result.d);
                            if (Data == "1") {
                                DisplayMsg('MM01', 'spnMsg');
                                LoadMapSet();
                            }
                            else if (Data == "2") {
                                DisplayMsg('MM024', 'spnMsg');
                            }
                            else if (Data == "0") {
                                DisplayMsg('MM05', 'spnMsg');
                            }

                        },
                        error: function (xhr, status) {
                            alert("Error ");
                            window.status = status + "\r\n" + xhr.responseText;
                            return false;
                        }
                    });
                }
                else {
                    $("#spnMsg").text("Please Select Medicine Set");
                    $("#ddlSelectSet").focus();
                }
            }
            else {
                $("#spnMsg").text("Please Select Doctor");
                $("#ddlDoctor").focus();
            }
            
        }
        function DeleteData(rowid) {
            var ID = $(rowid).closest('tr').find("#Td2").text();
                 $.ajax({
                     url: "Set_MedicalSet_DoctorWise.aspx/RemoveSet",
                     data: '{ID:"' + ID + '" }', // parameter map
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     async: false,
                     success: function (result) {
                         Data = result.d;
                         if (Data == "1") {
                             DisplayMsg('MM02', 'spnMsg');
                             LoadMapSet();
                         }
                         else {
                             DisplayMsg('MM124', 'spnMsg');
                         }
                         $("#btnSave").attr('disabled', false);
                     },
                     error: function (xhr, status) {
                         alert(status + "\r\n" + xhr.responseText);
                         DisplayMsg('MM05', 'spnMsg');
                         $("#btnSave").attr('disabled', false);
                         window.status = status + "\r\n" + xhr.responseText;
                     }
                 });
        }
        function chngcur() {
            document.body.style.cursor = 'pointer';

        }
    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b> Map The Set According To Doctor</b> <br /> 
             <span id="spnMsg" class="ItDoseLblError"></span>
         <span id="debugArea" class="ItDoseLblError"></span>  
        </div>
        <div class="POuter_Box_Inventory">
                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDoctor"  onchange="LoadMapSet()" class="searchable"></select>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Set Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSelectSet" onchange="LoadSetItems()"  class="searchable"></select>
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                <input type="button" value="Map Set" id="btnMapSet" class="ItDoseButton" onclick="MapSet()" />&nbsp;</td>
                            </label>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
         <div  class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                 Mapped Set
            </div>
              <table cellpadding="0" cellspacing="0" style="width: 100%" id="Table3">
                <tr >
                    <td colspan="4">
                       <div id="divMapping" style="height:200px;display:none;overflow-y:scroll;" >
                        </div>
                    </td>
                </tr>
            </table>
        </div>
         <div class="POuter_Box_Inventory" id="divINV">
             <div class="Purchaseheader">
                     Set Description
                </div>
             <table cellpadding="0" cellspacing="0" style="width: 100%" id="myTable">
                <tr >
                    <td colspan="4">
                      <div id="PatientMedicineSearchOutput" style="height:200px;display:none;overflow-y:scroll;" >
                        </div>
                    </td>
                </tr>
            </table>
             </div>
    </div>
                  <script id="tb_PatientMedicineSearch" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1"
    style="width:100%;border-collapse:collapse;">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">Set ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Set Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:65px; display:none">Item ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:380px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Quantity</th>
		</tr>

        <#
       
        var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
        
          #>
                    <tr id="<#=objRow.SetID#>|<#=objRow.ItemID#>" >
                        <td class="GridViewLabItemStyle"><#=j+1#></td>
                        <td id="Td1" class="GridViewLabItemStyle" style="display:none"><#=objRow.ID#></td>
                        <td id="SetID" class="GridViewLabItemStyle" style="display:none"><#=objRow.SetID#></td>
                        <td id="SetName" class="GridViewLabItemStyle"><#=objRow.setName#></td>
                        <td id="ItemID" class="GridViewLabItemStyle" style="display:none"><#=objRow.ItemID#></td>
                        <td  id="ItemName" class="GridViewLabItemStyle"><#=objRow.NAME#></td>
                        <td id="tdSetQuantity" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.quantity#></td>
                </tr>   

            <#}#>

     </table>    
    </script>

     <script id="tb_MapSet" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table2"
    style="width:940px;border-collapse:collapse;">
		<tr id="Tr2">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">Set ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Set Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Remove</th>
		</tr>

        <#
       
        var dataLength=Data.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {

        objRow = Data[j];
        
          #>
                    <tr id="Tr3" >
                        <td class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
                        <td id="Td2" class="GridViewLabItemStyle" style="display:none"><#=objRow.ID#></td>
                        <td id="Td3" class="GridViewLabItemStyle" style="display:none"><#=objRow.SetID#></td>
                        <td id="Td4" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.SetName#></td>
                         <td class="GridViewLabItemStyle" id="tdDelete" style="text-align:center;">
                    <img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteData(this)" onmouseover="chngcur()" title="Click To Remove"/>
                    </td>
                </tr>   

            <#}#>

     </table>    
    </script>

</asp:Content>


