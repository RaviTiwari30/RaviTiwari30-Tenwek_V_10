<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Pharmacy_Label_master.aspx.cs" Inherits="Design_Store_Pharmacy_Label_master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.tablednd.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript" ></script> 
     <script type="text/javascript">
         $(document).ready(function () {
             bindLabelMaster();
             chkType();
         });
         function bindLabelMaster() {
             $("#debugArea").html("");
             var Type = "";
             if ($("#rdoDose0").is(':checked')) {
                 type = "Dose";
             }
             else if ($("#rdoTime0").is(':checked')) {
                 type = "Time";
             }
             else if ($("#rdoDuration0").is(':checked')) {
                 type = "Duration";
             }
             else if ($("#rdoCaution0").is(':checked')) {
                 type = "Caution";
             }
             else if ($("#rdoMeal0").is(':checked')) {
                 type = "Meal";
             }
             else
                 type = "";
             $.ajax({
                 url: "Pharmacy_Label_master.aspx/bindLabelMaster",
                 data: '{Name:"' + type + '" }',
                 type: "POST",
                 async: false,
                 dataType: "json",
                 contentType: "application/json; charset=utf-8",
                 success: function (response) {
                     Remu = jQuery.parseJSON(response.d);
                     if (Remu != null) {
                         var output = $('#tb_SearchLabelMaster').parseTemplate(Remu);
                         $('#LabelOutput').html(output);
                         $('#LabelOutput').show();
                     }
                     else {
                         $('#LabelOutput').hide();
                     }
                     $('#tb_LabelMaster').tableDnD({
                         onDragClass: "myDragClass",

                         onDragStart: function (table, row) {
                             $("#spnMsg").text('');
                             $("#debugArea").html("Started dragging row " + row.id);
                         },
                         dragHandle: ".dragHandle"

                     });
                 }
             });
         }
         function chngcurmove() {
             document.body.style.cursor = 'move';
         }
         function SaveLabelData() {
             if (validate() == true) {
                 var Type = "";
                 var Quantity = "";
                 if ($("#rdoDose").is(':checked')) {
                     type = "Dose";
                     Quantity = "0";
                 }
                 else if ($("#rdoTime").is(':checked')) {
                     type = "Time";
                     Quantity = $.trim($('#txtQuantity').val());
                 }
                 else if ($("#rdoDuration").is(':checked')) {
                     type = "Duration";
                     Quantity = $.trim($('#txtQuantity').val());
                 }
                 else if ($("#rdoCaution").is(':checked')) {
                     type = "Caution";
                     Quantity = "0";
                 }
                 else if ($("#rdoMeal").is(':checked')) {
                     type = "Meal";
                     Quantity = "0";
                 }
                 $.ajax({
                     url: "Pharmacy_Label_master.aspx/Insert",
                     data: '{Name:"' + $.trim($('#txtName').val()) + '", Type:"' + type + '",Quantity:"' + Quantity + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     async: false,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1") {
                             DisplayMsg('MM01', 'spnMsg');
                             $('#txtName').val('');
                             $('#txtQuantity').val('');
                             $("#btnsave").removeProp('disabled');
                             chkType();
                         }
                         else if (result.d == "2") {
                             DisplayMsg('MM24', 'spnMsg');
                             $('#txtName').focus();
                             $("#btnsave").removeProp('disabled');
                             chkType();
                         }
                         else if (result.d == "3") {
                             $("#spnMsg").text('Please Enter Name');
                             $('#txtName').focus();
                             $("#btnsave").removeProp('disabled');
                             chkType();
                         }
                         else {
                             DisplayMsg('MM05', 'spnMsg');
                         }
                         bindLabelMaster();
                     },
                     error: function (xhr, status) {
                         DisplayMsg('MM05', 'spnMsg');
                         window.status = status + "\r\n" + xhr.responseText;
                     }
                 });
             }
            else {
                $('#btnsave').removeProp('disabled');
            }
       }
         function validate() {
             if ($.trim($("#txtName").val()) == "") {
                 $("#spnErrorMsg").text('Please Enter Name');
                 $('#txtName').focus();
                 return false;
             }
             if ($("#rdoTime").is(':checked') || ($("#rdoDuration").is(':checked'))) {
                 if ($.trim($("#txtQuantity").val()) == "") {
                     $("#spnErrorMsg").text('Please Enter Quantity');
                     $('#txtQuantity').focus();
                     return false;
                 }
             }
             return true;
         }
         function editLabel(rowid) {
             $("#NameID").text($(rowid).closest('tr').find('#tdID').text());
             $("#rdoDose,#rdoTime,#rdoDuration,#rdoCaution,#rdoMeal").prop('disabled', true);
             if ($(rowid).closest('tr').find('#tdType').text() == "Dose") {
                 $("#rdoDose").prop('checked', true);
                 chkType();
             }
             else if ($(rowid).closest('tr').find('#tdType').text() == "Time") {
                 $("#rdoTime").prop('checked', true);
                 chkType();
             }
             else if ($(rowid).closest('tr').find('#tdType').text() == "Duration") {
                 $("#rdoDuration").prop('checked', true);
                 chkType();
             }
             else if ($(rowid).closest('tr').find('#tdType').text() == "Caution") {
                 $("#rdoCaution").prop('checked', true);
                 chkType();
             }
             else if ($(rowid).closest('tr').find('#tdType').text() == "Meal") {
                 $("#rdoMeal").prop('checked', true);
                 chkType();
             }
             $('#btnUpdate').show();
              $('#btnsave').hide();
             $('#btnCancel').show();
             $('#txtName').val($(rowid).closest('tr').find('#tdName').text());
             $('#txtQuantity').val($(rowid).closest('tr').find('#tdQuantity').text());
             if ($(rowid).closest('tr').find('#tdIsActive').text() == "Yes")
                 $("#rbActive").prop('checked', true);
             else
                 $("#rbDeActive").prop('checked', true);
         }
         function CancelUpdation()
         {
             $("#rdoDose").prop('checked', true);
             $('#txtName').val('');
             $('#txtQuantity').val('');
             $("#rbActive").prop('checked', true);
             $('#btnsave').show();
             $('#btnUpdate').hide();
             $('#btnCancel').hide();
             $("#rdoDose").prop('disabled', false);
             $("#rdoTime").prop('disabled', false);
             $("#rdoDuration").prop('disabled', false);
             chkType();
         }
         function UpdateLabelData()
         {
             if (validate() == true) {
                 var Type = "";
                 var Quantity = "";
                 if ($("#rdoDose").is(':checked')) {
                     type = "Dose";
                     Quantity = "0";
                 }
                 else if ($("#rdoTime").is(':checked')) {
                     type = "Time";
                     Quantity = $.trim($('#txtQuantity').val());
                 }
                 else if ($("#rdoDuration").is(':checked')) {
                     type = "Duration";
                     Quantity = $.trim($('#txtQuantity').val());
                 }
                 else if ($("#rdoCaution").is(':checked')) {
                     type = "Caution";
                     Quantity = "0";
                 }
                 else if ($("#rdoMeal").is(':checked')) {
                     type = "Meal";
                     Quantity = "0";
                 }
                 if ($("#rbActive").is(':Checked'))
                     Active = "1";
                 else
                     Active = "0";
                 $.ajax({
                     url: "Pharmacy_Label_master.aspx/Update",
                     data: '{Name:"' + $.trim($('#txtName').val()) + '",Type:"' + type + '",Active:"' + Active + '", ID:"' + $.trim($('#NameID').text()) + '",Quantity:"' + Quantity + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     async: false,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1") {
                             DisplayMsg('MM01', 'spnMsg');
                             $('#txtName').val('');
                             $("#btnsave").removeProp('disabled');
                             $("#btnsave").show();
                             $("#btnUpdate").hide();
                             $("#btnCancel").hide();
                             $("#rdoDose").prop('disabled', false);
                             $("#rdoTime").prop('disabled', false);
                             $("#rdoDuration").prop('disabled', false);
                             $('#txtQuantity').val('');
                             chkType();
                         }
                         else if (result.d == "2") {
                             DisplayMsg('MM024', 'spnMsg');
                             $('#txtName').focus();
                             $("#btnsave").removeProp('disabled');
                         }
                         else if (result.d == "3") {
                             $("#spnMsg").text('Please Enter Name');
                             $('#txtName').focus();
                             $("#btnsave").removeProp('disabled');
                         }
                         else {
                             DisplayMsg('MM05', 'spnMsg');
                         }
                         bindLabelMaster();
                     },
                     error: function (xhr, status) {
                         DisplayMsg('MM05', 'spnMsg');
                         window.status = status + "\r\n" + xhr.responseText;
                     }
                 });
             }
             else {
                 $('#btnsave').removeProp('disabled');
             }
         }
         function checkForSecondDecimal(sender, e) {
             var charCode = (e.which) ? e.which : e.keyCode;
             if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                 $("#spnMsg").text('Enter Numeric Value Only');
                 return false;
             }
             else {
                 $("#spnMsg").text(' ');
             }
             strLen = sender.value.length;
             strVal = sender.value;
             hasDec = false;
             e = (e) ? e : (window.event) ? event : null;
             if (e) {
                 var charCode = (e.charCode) ? e.charCode :
                                 ((e.keyCode) ? e.keyCode :
                                 ((e.which) ? e.which : 0));
                 if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                     for (var i = 0; i < strLen; i++) {
                         hasDec = (strVal.charAt(i) == '.');
                         if (hasDec)
                             $("#spnMsg").text('Enter Numeric Value Only');
                         return false;
                     }
                 }
             }
             else {
                 $("#spnMsg").text(' ');
             }
         }
         function chkType() {
             if ($("#rdoTime").is(":checked") || $("#rdoDuration").is(":checked")) {
                 $('#txtQuantity').attr('disabled', false);
                 $('#Label2').show();
             }
             else {
                 $('#txtQuantity').attr('disabled', true);
                 $('#Label2').hide();
             }
         }
         function UpdateSequenceNo()
         {
             var seq = [];
             $("#tb_LabelMaster tr").each(function () {
                 var id = $(this).attr("id");
                var $rowid = $(this).closest("tr")
                 if (id != "Header") {
                     seq.push({"SequenceNo": id, "ID": $.trim($rowid.find("#tdID").text()) });
                 }
             });
             $.ajax({
                 url: "Pharmacy_Label_master.aspx/UpdateSequenceNo",
                 data: JSON.stringify({ Data: seq }),
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 async: false,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == "1") {
                         $('#spnMsg').text("Sequence No. Updated");
                         bindLabelMaster();
                     }
                 }
             });
         }
     </script>
     <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Create Label Master</b>
            <br />
             <span id="spnMsg" class="ItDoseLblError"></span><br />
            <span id="debugArea" class="ItDoseLblError"></span> 
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <table id="Table1" runat="server" style="text-align: left; width: 945px;">
                <tr>
                    <td align="right">
 <asp:Label ID="lblType" runat="server" Text="Type :&nbsp;" Width="207px" ></asp:Label></td><td>
                           <input id="rdoDose" type="radio" name="Label" value="Dose" onclick="chkType()" />Dose
             <input id="rdoTime" type="radio" name="Label" value="Time" onclick="chkType()" />Time 
                    <input id="rdoDuration" type="radio" name="Label" value="Duration" onclick="chkType()" />Duration 
     <input id="rdoCaution" type="radio" name="Label" value="Caution" onclick="chkType()" />Caution
     <input id="rdoMeal" type="radio" name="Label" value="Meal" onclick="chkType()" />Meal
                        </td>
                </tr>
                <tr>
                    <td align="right">
                       
                        <asp:Label ID="lblName" runat="server" Text="Name :&nbsp;" Width="114px" ></asp:Label></td>
                    <td>
                         <input type="text" id="txtName" maxlength="20" style="width:180px" />
                        <span id="NameID" style="display:none"></span>
                        <asp:Label ID="Label1" runat="server" Text="*" ForeColor="Red" ></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                       
                       Quantity :&nbsp;</td>
                    <td>
                         <input type="text" id="txtQuantity" maxlength="5" style="width:180px" onkeypress="return checkForSecondDecimal(this,event)" />
                         <asp:Label ID="Label2" ClientIDMode="Static" runat="server" Text="*" ForeColor="Red" ></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Label ID="lblActive" runat="server" Text="Is Active :&nbsp;" Width="108px"></asp:Label></td><td>
                           <input id="rbActive" type="radio" name="IsActive" value="Active"   checked="checked">Active
             <input id="rbDeActive" type="radio" name="IsActive" value="DeActive" />DeActive</td>
                </tr>
                <tr align="center">
                    <td style="height: 26px" align="right">
                       </td><td align="left">
                           <input id="btnsave" type="button" value="Save" class="ItDoseButton" onclick="SaveLabelData()"/>                         
                            <input id="btnUpdate" type="button" value="Update" class="ItDoseButton" style="display:none" onclick="UpdateLabelData()"/>
                           <input id="btnCancel" type="button" value="Cancel" class="ItDoseButton" style="display:none" onclick="CancelUpdation()"/>
                    </td>
                </tr>
            </table>
        </div>
         <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">
             Search Result
                 <input id="rdoALL" checked="checked" name="Label" onclick="bindLabelMaster()" type="radio" value="ALL" />ALL
                 <input id="rdoDose0" name="Label" onclick="bindLabelMaster()" type="radio" value="Dose1" />Dose
                 <input id="rdoTime0" name="Label" onclick="bindLabelMaster()" type="radio" value="Time1" />Time
                 <input id="rdoDuration0" name="Label" onclick="bindLabelMaster()" type="radio" value="Duration1" />Duration
                 <input id="rdoCaution0" name="Label" onclick="bindLabelMaster()" type="radio" value="Caution1" />Caution
                 <input id="rdoMeal0" name="Label" onclick="bindLabelMaster()" type="radio" value="Meal1" />Meal</div>
         <table>
         <tr style="width:100%">
                    <td colspan="3" style="text-align:center">
                        <div id="LabelOutput" style="max-height: 700px; overflow-x: scroll;overflow-y:scroll; text-align:center">
                        </div></td></tr>
             <tr style="text-align:center">
                 <td colspan="3"><input type="button" value="Save Sequence No." id="btnSequenceNo" class="ItDoseButton" onclick="UpdateSequenceNo()" /></td>
             </tr>
         </table></div>
    </div>
     <script id="tb_SearchLabelMaster" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_LabelMaster"
    style="width:700px;border-collapse:collapse; text-align:center">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:250px;">Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Quantity</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Sequence No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Active</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Edit</th>
		</tr>
        <#
        var objRow;
        for(var j=0;j<Remu.length;j++)
        {
        objRow = Remu[j];
        #>
                    <tr id="<#=j+1#>">
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdName"  style="width:250px;text-align:center" onmouseover="chngcurmove()" ><#=objRow.NAME#></td>
                    <td class="GridViewLabItemStyle" id="tdQuantity"  style="width:60px;text-align:center" ><#=objRow.Quantity#></td>
                        <td class="GridViewLabItemStyle" id="tdSequenceNo"  style="width:60px;text-align:center" ><#=objRow.SequenceNo#></td>
                    <td class="GridViewLabItemStyle" id="tdID"  style="width:50px;text-align:center;display:none" ><#=objRow.ID#></td>
                    <td class="GridViewLabItemStyle" id="tdType"  style="width:100px;text-align:center" ><#=objRow.TYPE#></td>
                    <td class="GridViewLabItemStyle" id="tdIsActive"  style="width:100px;text-align:center" ><#=objRow.isactive#></td>
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center">
                    <img alt="Edit" id="btnEdit" src="../../Images/edit.png" onclick="editLabel(this);" style="cursor:pointer" />
                    </td>
                    </tr>
        <#}
        #>
     </table>
    </script>
</asp:Content>

