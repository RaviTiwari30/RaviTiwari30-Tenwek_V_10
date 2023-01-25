<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
 CodeFile="DoctorDepartmentMaster.aspx.cs" Inherits="Design_Doctor_DoctorDepartmentMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" />

     <div id="Pbody_box_inventory" >
    <div class="POuter_Box_Inventory" style="text-align:center;">
    
     <b>  Doctor Department Master</b><br />
          
            <asp:Label ID="lblmsg" runat="server" ClientIDMode="Static"  CssClass="ItDoseLblError"></asp:Label>
    </div>
      <div class="POuter_Box_Inventory" >
     <div class="Purchaseheader">
                      Department Master
         &nbsp;</div>
       <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                  <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                        </div>
                        <div class="col-md-4">
                        </div>
                          <div class="col-md-4">
                            <label class="pull-left">
                               New Department
                            </label>
                           <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtDepartment" runat="server" Width="95%"  ClientIDMode="Static"
                     ToolTip ="Enter New Department" TabIndex ="1" MaxLength="50"></asp:TextBox>
                          <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                 <span id="spnDepartmentID" style="display:none"></span>  
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                         <div class="col-md-12">
                        </div>
                         <div class="col-md-1">
                                <input type="button" value="Update"  style="display:none" class="ItDoseButton" id="btnUpdate" onclick="updateDocDepartment()" />
                        </div>
                         <div class="col-md-1">
                               <input type="button" value="Save" class="ItDoseButton" id="btnSave" onclick="saveDocDepartment()" />
                        </div>
                         <div class="col-md-1">
                            <input type="button" value="Cancel"  style="display:none" class="ItDoseButton" id="btnCancel" onclick="cancelDocDepartment()" />
                        </div>
                        <div class="col-md-9">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
         </div>
       
    <div class="POuter_Box_Inventory" style="text-align: center;">
    

        <div id="docDepartmentOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
              </div>
         
 
   </div>  
    <script id="tb_grdDocSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_DocSearch"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Department</th>                      
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Edit</th>
		</tr>
        <#       
        var dataLength=DocDepartmentData.length;
      if(_EndIndex>dataLength)
            {           
               _EndIndex=dataLength;
            }
        for(var j=_StartIndex;j<_EndIndex;j++)
            {              
            
        var objRow = DocDepartmentData[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdID"  style="width:40px;display:none" ><#=objRow.ID#></td>                  
                    <td class="GridViewLabItemStyle" id="tdName" style="width:200px;"><#=objRow.Name#></td>  
                       
                       
                                                                
                   <td class="GridViewLabItemStyle">
                       <img src="../../Images/edit.png" style="cursor:pointer" onclick="DocDepartment(this)"  title="Click To Edit"/>
                   </td>
                    </tr>           
        <#}#>                     
     </table>   
        <table id="tableDocCount" style="border-collapse:collapse;">
       <tr>
<# 
     for(var j=0;j<_PageCount;j++){ #>
     <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
     <#}         
           
    
#>


     </tr>
     
     </table>   
    </script>
     <script type="text/javascript">
         function saveDocDepartment() {
             $("#btnSave").attr('disabled', 'disabled');
             if ($.trim($("#txtDepartment").val()) != "") {
                 $("#lblmsg").text('');
                 $.ajax({
                     url: "services/DocGrouprateMaster.asmx/SaveDocDepartment",
                     data: '{DocDepartmentName:"' + $.trim($("#txtDepartment").val()) + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1") {
                             DisplayMsg('MM01', 'lblmsg');
                         }
                         else if (result.d == "2") {
                             $("#lblmsg").text('Doctor Department Already Exits');
                             $("#btnSave").removeAttr('disabled');
                             return;
                         }
                         else {
                             DisplayMsg('MM05', 'lblmsg');
                         }
                         hideDetail();
                         $("#btnSave").removeAttr('disabled');
                     },
                     error: function (xhr, status) {
                         window.status = status + "\r\n" + xhr.responseText;

                         DisplayMsg('MM05', 'lblmsg');
                     }
                 });
             }

             else {
                 $("#lblmsg").text('Please Enter Doctor Department');
                 $("#btnSave").removeAttr('disabled');
             }
         }
         var _PageSize = 10;
         var _PageNo = 0;
         var DocDepartmentData = "";
         function bindDocDepartment() {
             $.ajax({
                 url: "services/DocGrouprateMaster.asmx/bindDocDepartment",
                 data: '{}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d != "") {
                         DocDepartmentData = jQuery.parseJSON(result.d);
                         if (DocDepartmentData != null) {

                             _PageCount = DocDepartmentData.length / _PageSize;
                             showPage('0');
                         }
                     }
                     else {
                         $('#docDepartmentOutput').html();
                         $('#docDepartmentOutput').hide();
                         DisplayMsg('MM04', 'lblmsg');

                     }
                 },
                 error: function (xhr, status) {
                     window.status = status + "\r\n" + xhr.responseText;
                     $('#docDepartmentOutput').html();
                     $('#docDepartmentOutput').hide();
                     DisplayMsg('MM05', 'lblmsg');
                 }
             });
         }
         function showPage(_strPage) {
             _StartIndex = (_strPage * _PageSize);
             _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
             var output = $('#tb_grdDocSearch').parseTemplate(DocDepartmentData);
             $('#docDepartmentOutput').html(output);
             $('#docDepartmentOutput').show();

         }
         function hideDetail() {
             bindDocDepartment();
             $("#btnSave").show();
             $("#btnUpdate,,#btnCancel").hide();
             $("#txtDepartment").val('');
         }
         $(function () {
             bindDocDepartment();
         });

         function DocDepartment(rowid) {
             $("#lblmsg").text('');
             var ID = $(rowid).closest('tr').find("#tdID").text();
             $("#btnSave").hide();
             $("#btnUpdate,#btnCancel").show();
             $("#txtDepartment").val($(rowid).closest('tr').find("#tdName").text());
             $("#spnDepartmentID").text(ID);
             $("#txtDepartment").focus();
             $('#txtDepartment').setCursorToTextEnd();
         }
         (function ($) {
             $.fn.setCursorToTextEnd = function () {
                 $initialVal = this.val();
                 this.val($initialVal + ' ');
                 this.val($initialVal);
             };
         })(jQuery);
         function updateDocDepartment() {
             $("#btnUpdate").attr('disabled', 'disabled');
             if ($.trim($("#txtDepartment").val()) != "") {
                 $("#lblmsg").text('');
                 $.ajax({
                     url: "services/DocGrouprateMaster.asmx/UpdateDocDepartment",
                     data: '{DocDepartmentName:"' + $.trim($("#txtDepartment").val()) + '",ID:"' + $("#spnDepartmentID").text() + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1") {
                             DisplayMsg('MM02', 'lblmsg');
                         }
                         else if (result.d == "2") {
                             $("#lblmsg").text('Doctor Department Already Exits');
                             $("#btnUpdate").removeAttr('disabled');
                             return;
                         }
                         else {
                             DisplayMsg('MM05', 'lblmsg');
                         }
                         hideDetail();
                         $("#btnUpdate").removeAttr('disabled');
                     },
                     error: function (xhr, status) {
                         window.status = status + "\r\n" + xhr.responseText;

                         DisplayMsg('MM05', 'lblmsg');
                     }
                 });
             }

             else {
                 $("#lblmsg").text('Please Enter Doctor Department');
                 $("#btnUpdate").removeAttr('disabled');
             }
         }

         function cancelDocDepartment() {
             $("#btnSave").show();
             $("#btnUpdate,#btnCancel").hide();
             $("#txtDepartment").val('');
             $("#lblmsg").text('');
         }
         </script>
</asp:Content>

