<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MicroMaster.aspx.cs" Inherits="Design_Investigation_MicroMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <script type="text/javascript" language="javascript">


       $(document).ready(function () {
           getmasterdata();
       });
       function savemasterdata() {

           if ($('#<%=txtname.ClientID%>').val() == "") {
              // $('#<%=lblMsg.ClientID%>').html("Please Enter Name");
               modelAlert('Please Enter Name');
               $('#<%=txtname.ClientID%>').focus();
               return;
           }

           var active = "0";
           if ($('#<%=chactive.ClientID%>').is(':checked')) {
                 active = "1";
             }
             var code = "";
             // $.blockUI();
             $.ajax({
                 url: "../Lab/Services/LabCulture.asmx/savemasterdata",
                 data: '{ typeid:"' + $('#<%=ddlmastertype.ClientID%> option:selected').val() + '", typename:"' + $('#<%=ddlmastertype.ClientID%> option:selected').text() + '", name:"' + $('#<%=txtname.ClientID%>').val() + '", status:"' + active + '",code:"' + $('#<%=txtcode.ClientID%>').val() + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == "1") {
                       //  $('#<%=lblMsg.ClientID%>').html("Record Saved Sucessfully..!");
                        // modelAlert('Record Saved Sucessfully..!');
                        
                         $('#<%=txtname.ClientID%>').val('');
                         $('#<%=txtcode.ClientID%>').val('');
                         $('#<%=chactive.ClientID%>').attr('checked', 'checked');
                         modelAlert('Record Saved Sucessfully', function (response) {
                             getmasterdata();
                         });
                     }
                     // // // $.unblockUI();

                 },
                 error: function (xhr, status) {
                     modelAlert(xhr.responseText);
                     // // $.unblockUI();
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }

         function updatemasterdata() {

             if ($('#<%=txtname.ClientID%>').val() == "") {
                // alert("Please Enter Name");
                 modelAlert('Please Enter Name');
                 $('#<%=txtname.ClientID%>').focus();
                 return;
             }

             var active = "0";
             if ($('#<%=chactive.ClientID%>').is(':checked')) {
                 active = "1";
             }
             var code = "";
             // $.blockUI();
             $.ajax({
                 url: "../Lab/Services/LabCulture.asmx/updatemasterdata",
                 data: '{id:"' + $('#masterid').html() + '", name:"' + $('#<%=txtname.ClientID%>').val() + '", status:"' + active + '",code:"' + $('#<%=txtcode.ClientID%>').val() + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == "1") {
                         // $('#<%=lblMsg.ClientID%>').html("Record Update Sucessfully..!");
                        
                        // modelAlert('Record Updated Sucessfully..!');
                         $('#<%=txtname.ClientID%>').val('');
                         $('#<%=txtcode.ClientID%>').val('');
                         $('#<%=chactive.ClientID%>').attr('checked', 'checked');
                         modelAlert('Record Updated Sucessfully', function (response) {
                             getmasterdata();
                         });
                        
                         $('#masterid').html('');
                         $('#btnsave').show();
                         $('#btnupdate').hide();
                         $('#<%=ddlmastertype.ClientID%>').attr('disabled', false);
                         // // $.unblockUI();
                     }

                 },
                 error: function (xhr, status) {
                     modelAlert(xhr.responseText);
                     // // $.unblockUI();
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });

         }

         function getmasterdata() {
             // $.blockUI();
             $.ajax({
                 url: "../Lab/Services/LabCulture.asmx/getmasterdata",
                 data: '{ typeid:"' + $('#<%=ddlmastertype.ClientID%> option:selected').val() + '", typename:"' + $('#<%=ddlmastertype.ClientID%> option:selected').text() + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {

                     MasterData = jQuery.parseJSON(result.d);
                     var output = $('#tb_MasterData').parseTemplate(MasterData);
                     $('#divmaster').html(output);
                     // // $.unblockUI();

                 },
                 error: function (xhr, status) {
                     modelAlert(xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }

         function showdata(id, name, code, status) {
             $('#<%=txtname.ClientID%>').val(name);
             $('#<%=txtcode.ClientID%>').val(code);
             $('#masterid').html(id);
             $('#btnsave').hide();
             $('#btnupdate').show();
             $('#<%=ddlmastertype.ClientID%>').attr('disabled', 'disabled');

             if (status == "1") {
                 $('#<%=chactive.ClientID%>').attr('checked', true);
             }
             else {
                 $('#<%=chactive.ClientID%>').attr('checked', false);
             }
         }



         function openwindow(id, typeid) {
             window.open("MapMicroMaster.aspx?id=" + id + "&typeid=" + typeid);
         }
      </script>


     <script id="tb_MasterData" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="width:100%;border-collapse:collapse;text-align:left;">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:15px;">Sr.No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Code</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Type</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">Status</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">InsertBy</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">InsertDate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">LastUpdateBy</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">LastUpdateDate</th>
	        <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Edit</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Tag</th>
</tr>



       <#
       
              var dataLength=MasterData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = MasterData[j];

         
            #>
                    <tr id="<#=objRow.id#>" >
<td id="srno" class="GridViewLabItemStyle"><#=j+1#></td>
<td id="Code" class="GridViewLabItemStyle"><#=objRow.Code#></td>
<td id="NAME" class="GridViewLabItemStyle"><#=objRow.NAME#></td>
<td id="typename" class="GridViewLabItemStyle"><#=objRow.typename#></td>
<td id="STATUS"  class="GridViewLabItemStyle"><#=objRow.STATUS#></td>
<td id="InsertByname"  class="GridViewLabItemStyle"><#=objRow.InsertByname#></td>
<td id="entrydate"  class="GridViewLabItemStyle"><#=objRow.entrydate#></td>
<td id="UpdateByname"  class="GridViewLabItemStyle"><#=objRow.UpdateByname#></td>
<td id="updatedate"  class="GridViewLabItemStyle"><#=objRow.updatedate#></td>
<td id="edit"  class="GridViewLabItemStyle">
<a style="color:blue;text-decoration:underline;cursor:pointer;font-weight:bold;" onclick="showdata('<#=objRow.id#>','<#=objRow.NAME#>','<#=objRow.Code#>','<#=objRow.isactive#>')">Edit</a></td>
<td id="tag"  class="GridViewLabItemStyle">

    <# if(objRow.typeid=="1" || objRow.typeid=="3")
    {#>
<a style="color:blue;text-decoration:underline;cursor:pointer;font-weight:bold;" onclick="openwindow('<#=objRow.id#>','<#=objRow.typeid#>')">Tag</a>
    <#}#>
</td>
</tr>


            <#}#>

     </table> 
           
    </script>



     <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div  style="text-align: center;">
                <b>MicroBiology Master</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            </div>
         <div class="POuter_Box_Inventory"  >
   <div class="Purchaseheader" style="width: 1291px; " > 
        <div class="row"> Master Entry</div>
       </div>
       <div class="row" id="TBMain">
            <div class="col-md-3" id="dtDept" runat="server">
                    <label class="pull-left">
                        Master Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <asp:DropDownList ID="ddlmastertype" runat="server" Width="202px" onchange="getmasterdata()"></asp:DropDownList>
                </div>
           <div class="col-md-3"   >
                    <label class="pull-left">
                        Name
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <asp:TextBox ID="txtname" CssClass="requiredField" runat="server" Width="200px" MaxLength="200"></asp:TextBox>
                    <span id="masterid" style="display:none;"></span>
                </div>
            <div class="col-md-3"   >
                    <label class="pull-left">
                        Code
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                  <asp:TextBox ID="txtcode" runat="server" Width="200px" MaxLength="200"></asp:TextBox>
                    <span id="Span1" style="display:none;"></span>
                </div>
           
       </div>
             <div class="row"> 
                 <div class="col-md-4" style="margin-left: 25px;">
                  <b class="pull-right">  <asp:CheckBox ID="chactive" runat="server" Checked="true" Text="Active" /></b>
                     </div>
             </div>
             </div>


          <div class="POuter_Box_Inventory"  >
                
            <div style="text-align: center;">
                 <table width="100%">
                   <tr>
                 <td align="center"><input type="button" value="Save" class="ItDoseButton" onclick="savemasterdata()" id="btnsave" />
                     &nbsp;&nbsp;
                     <input type="button" value="Mapping" class="ItDoseButton" id="btnmapping" style="display:none;" />
                     <input type="button" value="Update" class="ItDoseButton" onclick="updatemasterdata()" id="btnupdate" style="display:none;" />
                 </td>
            </tr>
        </table>
             </div>



         </div>


           <div class="POuter_Box_Inventory" >
                  <div class="Purchaseheader">Master Detail</div>
            <div style="text-align: center;">

                <div id ="divmaster" style="overflow:scroll;height:360px;width:100%;">

</div>

                </div></div>
         </div>
</asp:Content>

