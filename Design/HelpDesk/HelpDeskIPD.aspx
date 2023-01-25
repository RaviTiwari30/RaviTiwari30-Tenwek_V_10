<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="HelpDeskIPD.aspx.cs" Inherits="Design_HelpDesk_HelpDeskIPD" Title="Untitled Page" %>
       <%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script type="text/javascript" >
        $(document).ready(function () {
            $('#txtFDSearch').change(function () {
                ChkDate();
            });
            $('#txtTDSearch').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFDSearch').val() + '",DateTo:"' + $('#txtTDSearch').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }
        var _PageSize = 100;
        var _PageNo = 0;
        var IPD = "";
        function searchIPD() {
            $("#lblMsg").text('');
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/IPDDetail",
                data: '{FDSearch:"' + $("#txtFDSearch").val() + '",type:"' + $("#rblipd input[type:radio]:checked").next().text() + '",City:"' + $("#txtCity").text() + '",TDSearch:"' + $("#txtTDSearch").val() + '",  PatientID:"' + $("#txtMRNo").val() + '", PName:"' + $("#txtName").val() + '",  ContactNo:"' + $("#txtMobile").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    IPD = jQuery.parseJSON(response.d);
                    if (IPD != null) {
                        $("#spnTotalRecord").html("Total Record :&nbsp;" + IPD.length);
                        _PageCount = IPD.length / _PageSize;
                        showPage('0');
                    }
                    else {
                        DisplayMsg('MM04', 'lblMsg');
                        $('#IPDOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblMsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
        function showPage(_strPage) {
            _StartIndex = (_strPage * _PageSize);
            _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
            var output = $('#tb_IPD').parseTemplate(IPD);
            $('#IPDOutput').html(output);
            $('#IPDOutput').show();
        }
</script> 
       <div id="Pbody_box_inventory" >
       <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
     <div class="POuter_Box_Inventory" style="text-align:center;">
    
        <b>IPD Patient Detail</b>
     <br/>
     <asp:Label ID="lblMsg" runat="server"  CssClass="ItDoseLblError" ClientIDMode="Static"  
            ></asp:Label>
      
      <asp:RadioButtonList ID="rblipd" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static"
         onclick="searchIPD()"  >
          <asp:ListItem Selected="True">Currently Admitted</asp:ListItem>
          <asp:ListItem>Admitted</asp:ListItem>
          <asp:ListItem>Discharged</asp:ListItem>
      </asp:RadioButtonList>
      </div>
        
     
   
    
    
    <div class="POuter_Box_Inventory" style="text-align: center; ">
    <div class="Purchaseheader" >
        Search Criteria</div>
        <div class="row">
            <div class="col-md-3">
                <label class="pull-left">
                    UHID
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <asp:TextBox ID="txtMRNo" ClientIDMode="Static"  runat="server" TabIndex="1" ></asp:TextBox>
            </div>
            <div class="col-md-3">
                <label class="pull-left">
                   Patient Name
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <asp:TextBox ID="txtName" runat="server" TabIndex="2" ClientIDMode="Static" ></asp:TextBox>
            </div>
            <div class="col-md-3">
                <label class="pull-left">
                    Contact No.
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
               <asp:TextBox ID="txtMobile" runat="server" 
                                                TabIndex="3" ClientIDMode="Static"  MaxLength="15"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="ftbContact" runat="server" TargetControlID="txtMobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
            </div>
        </div>

        <div class="row">
             <div class="col-md-3">
                <label class="pull-left">
                    City
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
               <asp:TextBox ID="txtCity" runat="server" AutoCompleteType="Disabled" TabIndex="4"  ClientIDMode="Static" ></asp:TextBox>
            </div>
            <div class="col-md-3">
                <label class="pull-left">
                   From Date
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
              <asp:TextBox ID="txtFDSearch" runat="server"   ToolTip="Enter Date" ClientIDMode="Static"  TabIndex="5"></asp:TextBox>
              <cc1:CalendarExtender ID="calfDate" TargetControlID="txtFDSearch" Format="dd-MMM-yyyy" Animated="true" runat="server"></cc1:CalendarExtender>
            </div>
            <div class="col-md-3">
                <label class="pull-left">
                    To Date
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
              <asp:TextBox ID="txtTDSearch" runat="server" ClientIDMode="Static" TabIndex="6" ></asp:TextBox>
                                    <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="txtTDSearch" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
            </div>
        </div>
        
    </div> 
         <div class="POuter_Box_Inventory">
               <center>
             <input type ="button" id="btnSearch"  tabindex="7"   value="Search" class="ItDoseButton" onclick="searchIPD()" />    </center>
        </div>  
     <div class="POuter_Box_Inventory" style="overflow:scroll" >
    <div class="Purchaseheader" >
        Search Result</div>
    <table cellpadding="0" cellspacing="0" style="width: 100%;"><tr>
     <td colspan="4">
                         <div id="IPDOutput" style="max-height: 600px;width:100%;">
                        </div>
                        <br />
                       
                    </td>
                </tr>
        <tr>
                    <td>
                        <span id="spnTotalRecord"></span>
                    </td>
                </tr>
                        </table>
    </div>
    
    
    </div>  
   
<script id="tb_IPD" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" 
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
<th class="GridViewHeaderStyle" scope="col" style="width:80px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Patient Name</th>
<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Contact No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Relation Of</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">DateOfAdmit</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">DateOfDischarge</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Doctor Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Ward Name</th>		
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;  ">Room No.</th>	
            	          <th class="GridViewHeaderStyle" scope="col" style="width:200px;  ">Bed No.</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;  ">Floor</th>
            	<th class="GridViewHeaderStyle" scope="col" style="width:50px;  ">Status</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;  ">Address</th>			 
                      
		</tr>
        <#       
        var dataLength=IPD.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        if(_EndIndex>dataLength)
            {           
               _EndIndex=dataLength;
            }
        for(var j=_StartIndex;j<_EndIndex;j++)
            {        
        objRow = IPD[j];
        #>
            

                    <tr id="<#=j+1#>" 
                        >                            
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle"   style="width:80px;text-align:center" ><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle"   style="width:80px;text-align:center" ><#=objRow.Pname#></td>
                    <td class="GridViewLabItemStyle"   style="width:80px;text-align:center" ><#=objRow.ContactNo#></td>
                    <td class="GridViewLabItemStyle" id="td1"  style="width:80px;text-align:center" ><#=objRow.Relation#></td>
                        <td class="GridViewLabItemStyle" id="tdDateOfAdmit"  style="width:80px;text-align:center" ><#=objRow.DateOfAdmit#></td>
                    <td class="GridViewLabItemStyle"   style="width:100px;text-align:center" ><#=objRow.DateOfDischarge#></td>
                    <td class="GridViewLabItemStyle"   style="width:90px;" ><#=objRow.Name#></td>
                        <td class="GridViewLabItemStyle"   style="width:200px;" ><#=objRow.RoomName#></td>
                    <td class="GridViewLabItemStyle"  style="width:200px;"><#=objRow.Room_No#></td>
                    <td class="GridViewLabItemStyle"  style="width:200px;"><#=objRow.Bed_No#></td>
                    <td class="GridViewLabItemStyle"  style="width:100px;"><#=objRow.Floor#></td>
                    <td class="GridViewLabItemStyle"  style="width:50px;"><#=objRow.Status#></td>
                    <td class="GridViewLabItemStyle"  style="width:100px;"><#=objRow.Address#></td>                  
                    </tr>            
        <#}        
        #>      
     </table>    
    <table>
       <tr>
    
     <#for(var j=0;j<_PageCount;j++){ #>
     <td><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
     <#}#>         
   
     </tr>
     
     </table> 
    </script>
   
     </asp:Content>
     
     
     
