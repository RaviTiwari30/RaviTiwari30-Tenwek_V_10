<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="HelpDeskOPD.aspx.cs" Inherits="Design_HelpDesk_HelpDeskOPD" Title="Untitled Page" %>
       
       <%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
       
       
       
      <asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
                     <script type="text/javascript" src="../../Scripts/Message.js"></script>

           <script type="text/javascript" >
               function searchOPD() {
                   $("#lblMsg").text('');
                   $.ajax({
                       type: "POST",
                       url: "HelpDeskOPD.aspx/BindOPDDetail",
                       data: '{PatientID:"' + $("#txtPatientID").val() + '",Name:"' + $("#txtName").val() + '",ContactNo:"' + $("#txtMobile").val() + '",City:"' + $("#txtCity").val() + '",FromDate:"' + $("#txtFDSearch").val() + '",ToDate:"' + $("#txtTDSearch").val() + '"}',
                       dataType: "json",
                       contentType: "application/json;charset=UTF-8",
                       async: false,
                       success: function (response) {
                           OPD = jQuery.parseJSON(response.d);
                           if (OPD != null) {
                               var output = $('#tb_OPD').parseTemplate(OPD);
                               $('#OPDOutput').html(output);
                               $('#OPDOutput').show();
                           }
                           else {
                               DisplayMsg('MM04', 'lblMsg');
                               $('#OPDOutput').hide();
                           }
                       },
                       error: function (xhr, status) {
                           DisplayMsg('MM05', 'lblMsg');
                           window.status = status + "\r\n" + xhr.responseText;

                       }

                   });
               }
        </script>
       <div id="Pbody_box_inventory" >
       <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
       <div class="POuter_Box_Inventory" style="text-align:center;">
        <b>OPD Detail</b><br/><asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"  ClientIDMode="Static"></asp:Label></div>
    <div class="col-md-3">
                <label class="pull-left"></label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5"></div>
    <div class="POuter_Box_Inventory" style="text-align: center; ">
    <div class="Purchaseheader" >
        Search Criteria</div>
        <div class="row">
            <div class="col-md-3">
                <label class="pull-left">UHID</label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5"> <asp:TextBox ID="txtPatientID" runat="server" TabIndex="1" ClientIDMode="Static"></asp:TextBox></div>
            <div class="col-md-3">
                <label class="pull-left">Patient Name</label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5"><asp:TextBox ID="txtName" runat="server" TabIndex="2" ClientIDMode="Static"></asp:TextBox></div>
            <div class="col-md-3">
                <label class="pull-left">Contact No.</label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5"><asp:TextBox ID="txtMobile" runat="server" TabIndex="3" ClientIDMode="Static"></asp:TextBox>
              <cc1:FilteredTextBoxExtender ID="ftbContact" runat="server" TargetControlID="txtMobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
</div>
        </div>
        <div class="row">
            <div class="col-md-3">
                <label class="pull-left">City</label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5"> <asp:TextBox ID="txtCity" runat="server" AutoCompleteType="Disabled" TabIndex="4" ClientIDMode="Static"></asp:TextBox></div>
            <div class="col-md-3">
                <label class="pull-left">Date From</label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">  <asp:TextBox ID="txtFDSearch" runat="server"  ToolTip="Click To Select From Date" TabIndex="5" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="txtFDSearch" Format="dd-MMM-yyyy" Animated="true" runat="server"></cc1:CalendarExtender>
            </div>
            <div class="col-md-3">
                <label class="pull-left">To Date</label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5"> <asp:TextBox ID="txtTDSearch" runat="server"  ToolTip="Click To Select From Date" TabIndex="6" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtTDSearch" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender></div>
        </div>
        
    </div> 
           <div class="POuter_Box_Inventory">
               <center>
             <input type ="button" tabindex="7"   value="Search" class="ItDoseButton" onclick="searchOPD()" /></center>
        </div>
     <div class="POuter_Box_Inventory" >
    <div class="Purchaseheader" >
        Search Result</div>
     <div id="OPDOutput" style="max-height: 600px;width:100%; overflow-x: auto;"></div><br /></div>
    </div>  
   <script id="tb_OPD" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" 
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Address</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Contact No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Sex</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Date of Visit</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Doctor Name</th>	
		</tr>
        <#       
        var dataLength=OPD.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = OPD[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                          
    
                    
                           <td class="GridViewLabItemStyle"  style="width:160px;"><#=objRow.PatientID#></td>
                        <td class="GridViewLabItemStyle"  style="width:240px;"><#=objRow.PName#></td>
                        <td class="GridViewLabItemStyle"  style="width:200px;"><#=objRow.Address#></td>
                        <td class="GridViewLabItemStyle"  style="width:120px;"><#=objRow.ContactNo#></td>
                        <td class="GridViewLabItemStyle"  style="width:70px;"><#=objRow.Gender#></td>
                        <td class="GridViewLabItemStyle"  style="width:90px;"><#=objRow.Dateofvisit#></td>
                        <td class="GridViewLabItemStyle"  style="width:180px;"><#=objRow.DName#></td>
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>
     </asp:Content>
     
     
