<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DoctorSpecialization.aspx.cs"
    Inherits="Design_Doctor_DoctorSpecialization" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script> 
    <script src="../../Scripts/Message.js" type="text/javascript"></script>  
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" />

    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                <b>Doctor Specialization Master</b><br />
                
                    <asp:Label ID="lblmsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>
           
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Specialization Master
       
            </div>
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
                                 New&nbsp;Specialization
                            </label>
                           <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSpecialization" ClientIDMode="Static" runat="server" Width="95%"
                            ToolTip="Enter Specialization Name" TabIndex="1" MaxLength="50"></asp:TextBox>

                       <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <span id="spnSpecializationID" style="display:none"></span>   
                        <span id="spnSpecializationold" style="display:none"></span>
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
                              <input type="button" value="Update"  style="display:none" class="ItDoseButton" id="btnUpdate" onclick="updateDocSpecialization()" />
                        </div>
                         <div class="col-md-1">
                              <input type="button" value="Save" class="ItDoseButton" id="btnSave" onclick="saveDocSpecialization()" />
                        </div>
                         <div class="col-md-1">
                             <input type="button" value="Cancel"  style="display:none" class="ItDoseButton" id="btnCancel" onclick="cancelDocSpecialization()" />
                        </div>
                        <div class="col-md-9">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style=" text-align: center;">

            <div id="docSpecializationOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
        </div>


    </div>
     <script id="tb_grdDocSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_DocSearch"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Specialization</th>                      
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Edit</th>
		</tr>
        <#       
        var dataLength=DocSpecializationData.length;
      if(_EndIndex>dataLength)
            {           
               _EndIndex=dataLength;
            }
        for(var j=_StartIndex;j<_EndIndex;j++)
            {              
            
        var objRow = DocSpecializationData[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdID"  style="width:40px;display:none" ><#=objRow.ID#></td>                  
                    <td class="GridViewLabItemStyle" id="tdName" style="width:200px;"><#=objRow.Name#></td>                                                                                                              
                   <td class="GridViewLabItemStyle">
                       <img src="../../Images/edit.png" style="cursor:pointer" onclick="DocSpecialization(this)"  title="Click To Edit"/>
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
         function saveDocSpecialization() {
             $("#btnSave").attr('disabled', 'disabled');
             if ($.trim($("#txtSpecialization").val()) != "") {
                 $("#lblmsg").text('');
                 $.ajax({
                     url: "services/DocGrouprateMaster.asmx/SaveDocSpecialization",
                     data: '{DocSpecialization:"' + $.trim($("#txtSpecialization").val()) + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1") {
                             DisplayMsg('MM01', 'lblmsg');
                         }
                         else if (result.d == "2") {
                             DisplayMsg('MM173', 'lblmsg');
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
                 $("#lblmsg").text('Please Enter Doctor Specialization');
                 $("#btnSave").removeAttr('disabled');
             }
         }
         var _PageSize = 10;
         var _PageNo = 0;
         var DocSpecializationData = "";
         function bindDocSpecialization() {
             $.ajax({
                 url: "services/DocGrouprateMaster.asmx/bindDocSpecialization",
                 data: '{}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d != "") {
                         DocSpecializationData = jQuery.parseJSON(result.d);
                         if (DocSpecializationData != null) {

                             _PageCount = DocSpecializationData.length / _PageSize;
                             showPage('0');
                         }
                     }
                     else {
                         $('#docSpecializationOutput').html();
                         $('#docSpecializationOutput').hide();
                         DisplayMsg('MM04', 'lblmsg');

                     }
                 },
                 error: function (xhr, status) {
                     window.status = status + "\r\n" + xhr.responseText;
                     $('#docSpecializationOutput').html();
                     $('#docSpecializationOutput').hide();
                     DisplayMsg('MM05', 'lblmsg');
                 }
             });
         }
         function showPage(_strPage) {
             _StartIndex = (_strPage * _PageSize);
             _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
             var output = $('#tb_grdDocSearch').parseTemplate(DocSpecializationData);
             $('#docSpecializationOutput').html(output);
             $('#docSpecializationOutput').show();

         }
         function hideDetail() {
             bindDocSpecialization();
             $("#btnSave").show();
             $("#btnUpdate,,#btnCancel").hide();
             $("#txtSpecialization").val('');
             $("#patientMasterData").text('');
         }
         $(function () {
             bindDocSpecialization();
         });

         function DocSpecialization(rowid) {
             $("#lblmsg").text('');
             var ID = $(rowid).closest('tr').find("#tdID").text();
             $("#btnSave").hide();
             $("#btnUpdate,#btnCancel").show();
             $("#txtSpecialization").val($(rowid).closest('tr').find("#tdName").text());
             $("#spnSpecializationold").text($(rowid).closest('tr').find("#tdName").text());
             $("#spnSpecializationID").text(ID);
             $("#txtSpecialization").focus();
             $('#txtDepartment').setCursorToTextEnd();
         }
         (function ($) {
             $.fn.setCursorToTextEnd = function () {
                 $initialVal = this.val();
                 this.val($initialVal + ' ');
                 this.val($initialVal);
             };
         })(jQuery);
         function updateDocSpecialization() {
             $("#btnUpdate").attr('disabled', 'disabled');
             if ($.trim($("#txtSpecialization").val()) != "") {
                 $("#lblmsg").text('');
                 $.ajax({
                     url: "services/DocGrouprateMaster.asmx/UpdateDocSpecialization",
                     data: '{DocSpecializationName:"' + $.trim($("#txtSpecialization").val()) + '",ID:"' + $("#spnSpecializationID").text() + '",Specialization:"' + $('#spnSpecializationold').text() + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1") {
                             DisplayMsg('MM02', 'lblmsg');
                         }
                         else if (result.d == "2") {
                             DisplayMsg('MM173', 'lblmsg');
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
                 $("#lblmsg").text('Please Enter Doctor Specialization');
                 $("#btnUpdate").removeAttr('disabled');
             }
         }

         function cancelDocSpecialization() {
             $("#btnSave").show();
             $("#btnUpdate,#btnCancel").hide();
             $("#txtSpecialization").val('');
             $("#lblmsg,#spnSpecializationold").text('');
         }
         </script>
</asp:Content>

