<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SurgeryGrouping.aspx.cs" Inherits="Design_EDP_SurgeryGrouping" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Surgery Grouping Master</b>         
            <div style="text-align: center">
                <input id="rdoNew" type="radio" name="Con" value="New" checked="checked" />New
           <input id="rdoEdit" type="radio" name="Con" value="Edit" />    Edit
            </div>
           <span id="spnErrorMsg" class="ItDoseLblError"></span>            
        </div>
        <div class="POuter_Box_Inventory">
             <div class="row" >
                <div class="col-md-3">
                      <label class="pull-left">Group</label>
                      <b class="pull-right">:</b>  
                </div>
                 <div class="col-md-5">
                      <asp:DropDownList ID="ddlSurgeryGroup" CssClass="requiredField" runat="server" ClientIDMode="Static" ></asp:DropDownList>
                    
                </div>
                 <div class="col-md-3">
                      <input type="button" id="btnNewGroup" style="display:none" class="pull-left ItDoseButton" value="New" title="Click To Create New Group" onclick="$showGroupPoupup()" />
                     </div>
                  <div class="col-md-3">
                      <label class="pull-left">Panel</label>
                              <b class="pull-right">:</b>  
                </div>
                 <div class="col-md-5">
                      <asp:DropDownList ID="ddlPanel" CssClass="requiredField" runat="server" ClientIDMode="Static"></asp:DropDownList>
                </div>
                 <div class="col-md-5">
                     </div>
                 </div>
            </div>
        <div class="POuter_Box_Inventory" style="text-align: center;display:none" id="divSearch">
          <input type="button" id="btnSearch" onclick="searchItem()" value="Search" class="ItDoseButton" style="display:none" />
            </div>
        <div id="divOutPut">
          <div class="POuter_Box_Inventory" style="text-align: center">
         <div id="SurgeryDataOutput" style="max-height: 500px; margin-left:24%; overflow-x: auto;">
                        </div>
             </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
             <input type="button" id="btnSave" onclick="saveItem()" value="Save" style="display:none" />

        </div></div>


         <div id="dvGroupPopup" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 525px;">
                <div class="modal-header">
                    <button type="button" class="close" onclick="$closeGroupPopup()" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Create New Group</h4><br />
                    <span id="spnErrorGroup" class="ItDoseLblError"></span>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-3" >
                            <label class="pull-left">Group</label>
                             <b class="pull-right">:</b>  
                        </div>
                         <div class="col-md-16">
                             <input type="text" id="txtNewGroupName" class="requiredFiled" maxlength="50" />
                        </div>
                        <div class="col-md-5">
                              <input id="btnSaveNewGroup" type="button" value="Save" onclick="SaveNewGroupName()" />
                        </div>
                    </div>
             </div>
                <div class="modal-footer">
                </div>
            </div>
            </div>
            </div>
        </div>
    <script type="text/javascript">
        function closeNewGroup() {
            $("#txtNewGroupName").val('');
            $("#spnErrorGroup").text('');
            $find('mpGroup').hide();
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpGroup')) {
                    $find('mpGroup').hide();
                    $("#txtNewGroupName").val('');
                    $("#spnErrorGroup").text('');
                }
                if ($find('mpDept')) {
                    $find('mpDept').hide();
                    $("#txtDepartment").val('');
                    $("#spnErrorDept").text('');
                }
            }
        }
    </script>
    <script type="text/javascript">
    $showGroupPoupup = function () {
            $('#dvGroupPopup').showModel();
        }
        $closeGroupPopup = function () {
            $('#dvGroupPopup').hideModel();
        }
    </script>
    <script type="text/javascript">
        
         function SaveNewGroupName() {
             if ($.trim(jQuery("#txtNewGroupName").val()) != "0") {
                 $.ajax({
                     url: "SurgeryGrouping.aspx/saveSurgeryGroupName",
                     data: '{GroupName: "' + $.trim(jQuery("#txtNewGroupName").val()) + '"}',
                     type: "Post",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     async: false,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1")
                             modelAlert("Group Created Successfully");
                         else if (result.d == "2")
                             $("#lblMsg").text('GroupName Already Exists');
                         else
                             modelAlert("Error Occured! Please Contact to administrator");

                         $closeGroupPopup();
                         bindSurgeryGroup();
                     },
                     error: function (xhr, status) {
                         modelAlert("Error Occured! Please Contact to administrator");
                     }
                 });
             }

             else {
                 $("#spnErrorGroup").text('Please Enter Group Name');
                 $("#txtNewGroupName").focus();
             }
         }
        </script>
     <script type="text/javascript">
         function searchItem() {
             $("#spnErrorMsg").text('');
             if ($("#ddlSurgeryGroup").val() != "0") {
                 $.ajax({
                     url: "SurgeryGrouping.aspx/searchSurgeryItem",
                     data: '{groupID:"' + $("#ddlSurgeryGroup").val() + '",panelID:"' + $("#ddlPanel").val() + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     async: true,
                     dataType: "json",
                     success: function (result) {
                         if (result.d != "") {
                             SurgeryData = jQuery.parseJSON(result.d);
                             if (SurgeryData != null) {
                                 var output = $('#tb_SurgeryData').parseTemplate(SurgeryData);
                                 $('#SurgeryDataOutput').html(output);
                                 $('#SurgeryDataOutput,#divOutPut,#btnSave').show();
                                 $('#btnSave').removeAttr('disabled');
                                 var TotalAmt = 0, TotalActualAmt=0;
                                 //$("#tb_grdSurgerySearch").find("#txtRate").each(function () {
                                 //    if ($(this).val() != "")
                                 //        TotalAmt = parseFloat(TotalAmt) + parseFloat(Number($(this).val()));
                                 //    if ($(this).closest('tr').find("#tdID").text() != "0") {

                                 //    }
                                 //});
                                 $("#tb_grdSurgerySearch").find("#tdFinalRate").each(function () {
                                     if ($(this).text() != "")
                                         TotalAmt = parseFloat(TotalAmt) + parseFloat(Number($(this).text()));
                                     if ($(this).closest('tr').find("#tdID").text() != "0") {

                                     }
                                 });
                                 //
                                 $("#tb_grdSurgerySearch").find("#tdTotal").html(TotalAmt.toFixed(2));

                                 $("#tb_grdSurgerySearch").find("#txtRate").each(function () {
                                     if ($(this).val() != "")
                                         TotalActualAmt = parseFloat(TotalActualAmt) + parseFloat(Number($(this).val()));
                                 });

                                 $("#tb_grdSurgerySearch").find("#tdActualTotal").html(TotalActualAmt.toFixed(2));

                                // $(".chkSelectSNo").prop('checked', 'checked');
                             }
                         }
                         else {
                             $('#SurgeryDataOutput').html('');
                             $('#SurgeryDataOutput,#divOutPut,#btnSave').hide();
                             $('#btnSave').removeAttr('disabled');
                         }
                         $("#btnSave").val('Update');
                     },
                     error: function (xhr, status) {
                         window.status = status + "\r\n" + xhr.responseText;
                         $('#SurgeryDataOutput').html('');
                         $('#SurgeryDataOutput').hide();
                         modelAlert("Error Occured! Please Contact to administrator");
                         $("#btnSave").val('Update');
                     }
                 });
             }

             else
             {
                 $("#spnErrorMsg").text('Please Select SurgeryGroup');
                 $("#ddlSurgeryGroup").focus();
                 $('#SurgeryDataOutput').html('');
                 $('#SurgeryDataOutput,#divOutPut,#btnSave').hide();
             }
         }

         </script>
         <script type="text/javascript">
             function surgeryItem() {
                 if ($('#tb_grdSurgerySearch tr').length > 0) {
                     var con = 0;
                     var dataItem = new Array();
                   
                     $("#tb_grdSurgerySearch tr").each(function () {
                         var id = $(this).attr("id");
                         var $rowid = $(this).closest("tr");                  
                         if ((id != "Header") && ($rowid.find('#chkSelectSNo').is(':checked'))) {
                             var ObjItem = new Object();
                             ObjItem.GroupID = $.trim(jQuery("#ddlSurgeryGroup").val())
                             ObjItem.GroupName = $.trim(jQuery("#ddlSurgeryGroup option:selected").text())
                             ObjItem.ItemName = $rowid.find("#tdTypeName").text();
                             ObjItem.ItemID = $rowid.find("#tdItemID").text();
                             ObjItem.Rate = $.trim($rowid.find("#txtRate").val());
                             //ObjItem.Rate = Number($.trim($rowid.find("#tdFinalRate").text()));
                             ObjItem.ScaleOfCost = Number($.trim($rowid.find("#tdScaleOfCost").text()));
                                 dataItem.push(ObjItem);
                                 ObjItem = new Object();
                             
                         }

                     });
                     return dataItem;
                 }
             }
             function validateItem() {
                 var con = 0; var tableCon = 1;
                 $("#tb_grdSurgerySearch tr").each(function () {
                     var id = $(this).attr("id");
                     var $rowid = $(this).closest("tr");
                     if (id != "Header") {
                         if ($rowid.find('#chkSelectSNo').is(':checked')) {                         
                             tableCon += 1;
                         }
                     }

                 });
               
                 if (tableCon == "1") {
                     $("#spnErrorMsg").text('Please Check Type Name');
                     return false;
                 }
                 return true;
             }

             function saveItem() {
                 if ($.trim(jQuery("#ddlSurgeryGroup").val()) != "0") {
                     if (validateItem() == true) {
                         var resultItem = surgeryItem();
                         $.ajax({
                             url: "SurgeryGrouping.aspx/saveSurgeryGrouping",
                             data: JSON.stringify({ Data: resultItem, saveType: $("#btnSave").val(), PanelID: $("#ddlPanel").val() }),
                             type: "Post",
                             contentType: "application/json; charset=utf-8",
                             timeout: 120000,
                             async: false,
                             dataType: "json",
                             success: function (result) {
                                 if (result.d == "1")
                                     modelAlert('Record Saved Successfully', function () {
                                         showNew();
                                     });
                                 else if (result.d == "2")
                                     modelAlert('Already Mapping Type Name With Group', function () {
                                         showNew();
                                     });
                                 else
                                     modelAlert('Error Occured! Please Contact to administrator');

                                 $("#rdoNew").attr('checked', true);
                                 $("#ddlSurgeryGroup").prop('selectedIndex',0);
                                 $("#btnSave").val('Save');
                             },
                             error: function (xhr, status) {
                                 modelAlert('Error Occured! Please Contact to administrator');
                             }
                         });
                     }
                 }

                 else {
                     $("#spnErrorMsg").text('Please Select Group Name');
                     $("#ddlSurgeryGroup").focus();
                 }
             }
             function showNew() {
                 $("#divOutPut,#btnSave,#btnNewGroup,#ddlSurgeryGroup").show();
                 $("#divSearch,#btnSearch").hide();
                 $("#ddlSurgeryGroup").prop('selectedIndex', 0);
                 $('#SurgeryDataOutput').html('');
                 bindSurgeryItem();
                 $("#spnErrorMsg").text('');
             }

             function showEdit() {
                 $("#divOutPut,#btnSave,#btnNewGroup").hide();
                 $("#divSearch,#btnSearch,#ddlSurgeryGroup").show();
                 $("#ddlSurgeryGroup").prop('selectedIndex', 0);
                 $("#spnErrorMsg").text('');
             }
             $(function () {
                 if ($("#rdoNew").is(':checked')) {
                     showNew();
                 }
                 if ($("#rdoEdit").is(':checked')) {
                     showEdit();

                 }

                 $("#rdoNew").bind("click", function () {
                     showNew();

                 });
                 $("#rdoEdit").bind("click", function () {
                     showEdit();

                 });

             });
    </script>
    <script type="text/javascript">
        $(function () {
            bindSurgeryGroup();
            bindSurgeryItem();
        });
        function bindSurgeryItem() {
            $.ajax({
                url: "SurgeryGrouping.aspx/loadSurgeryItem",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        SurgeryData = jQuery.parseJSON(result.d);
                        if (SurgeryData != null) {
                            var output = $('#tb_SurgeryData').parseTemplate(SurgeryData);
                            $('#SurgeryDataOutput').html(output);
                            $('#SurgeryDataOutput,#btnSave').show();
                            $('#btnSave').removeAttr('disabled');
                        }
                    }
                    else {
                        $('#SurgeryDataOutput').html('');
                        $('#SurgeryDataOutput,#btnSave').hide();
                        $('#btnSave').removeAttr('disabled');
                    }
                    $("#btnSave").val('Save');
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#SurgeryDataOutput').html('');
                    $('#SurgeryDataOutput').hide();
                    modelAlert('Error Occured! Please Contact to administrator');
                    $("#btnSave").val('Save');
                }
            });
        }
        function bindSurgeryGroup() {
            $("#ddlSurgeryGroup option").remove();
            $.ajax({
                url: "Services/EDP.asmx/bindSurgeryGroup",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    group = jQuery.parseJSON(result.d);
                    $("#ddlSurgeryGroup").append($("<option></option>").val('0').html('Select'));
                    if (!group == null) {
                        for (i = 0; i < group.length; i++) {
                            $("#ddlSurgeryGroup").append($("<option></option>").val(group[i].GroupID).html(group[i].GroupName));
                        }
                    }

                },
                error: function (xhr, status) {
                }
            });

        }
        function chkAll(rowID) {
            if ($(".chkAll").is(':checked')) {
                $(".chkSelectSNo").prop('checked', 'checked');
               
            }
            else {
                $(".chkSelectSNo").prop('checked', false);
               
            }
        }
        function chkSelect(rowID) {
            if ($(".chkSelectSNo").length == $(".chkSelectSNo:checked").length)
                $(".chkAll").attr("checked", "checked");
            else
                $(".chkAll").removeAttr("checked");
            
        }

        
    </script>
  <script id="tb_SurgeryData" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSurgerySearch"
    style="width:750px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">
                <input type="checkbox" class="chkAll"  onclick="chkAll(this)" /></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:380px;">Type Name</th>                      
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ItemID</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ID</th>   
             <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Scale of Cost</th>              
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Rate</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Final Rate</th>
		</tr>
        <#       
        var dataLength=SurgeryData.length;var TotalAmt=0,TotalActualAmt=0;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = SurgeryData[j];
        #>
                    <tr id="<#=j+1#>">                                                
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#> </td>
                        <td class="GridViewLabItemStyle" style="width:10px;" id="tdSelect">
                            <input type="checkbox" id="chkSelectSNo"  onclick="chkSelect(this)" class="chkSelectSNo" 
                            <#
                           if(SurgeryData[j].ID !="0")
                            {#>
                              checked="checked"
                           
                          <#} #>/>
                       </td>
                    <td class="GridViewLabItemStyle" id="tdTypeName" style="width:420px;"><#=objRow.TypeName#></td>
                    <td class="GridViewLabItemStyle" id="tdItemID" style="width:40px;display:none"><#=objRow.ItemID#></td>
                    <td class="GridViewLabItemStyle" id="tdID" style="width:40px;display:none"><#=objRow.ID#></td>
                    <td class="GridViewLabItemStyle" id="tdScaleOfCost" style="width:120px;"><#=objRow.ScaleOfCost#></td>
                    <td class="GridViewLabItemStyle" id="tdRate" style="width:120px;text-align:right">
                       <input type="text" maxlength="100" onpaste="return false" style="width:80px" value="<#=objRow.Rate#>"  id="txtRate" onkeypress="return checkForSecondDecimal(this,event)" class="ItDoseTextinputNum"  onkeyup="CheckQty(this);"/>
                      
                      </td>  
                         <td class="GridViewLabItemStyle" id="tdFinalRate" style="width:120px; text-align:right;"><#=objRow.FinalRate#></td>                     
                    </tr>   
        <#}#>  
        <tr style="background-color:#90EE90;font-size:16px">
        <td style="width:10px;"></td>
       <td></td><td></td><td style="width:40px;display:none"></td><td style="width:40px;display:none"></td>
        <td>Total</td>
         <td id="tdActualTotal"  style="text-align:right"><#=TotalActualAmt.toFixed(2)#></td>             
         <td  id="tdTotal"  style="text-align:right"><#=TotalAmt.toFixed(2)#></td>
        </tr>                   
     </table>    
    </script>
    <script type="text/javascript">
        function checkForSecondDecimal(sender, e) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            formatBox = document.getElementById(sender.id);
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
                            return false;
                    }
                }
            }
            return true;
        }
        function CheckQty(Qty) {
            var Amt = $(Qty).val();
            if (Amt.match(/[^0-9\.]/g)) {
                Amt = Amt.replace(/[^0-9\.]/g, '');
                $(Qty).val(Number(Amt));
                return;
            }
            if (Amt.charAt(0) == "0") {
                $(Qty).val(Number(Amt));
            }
            if (Amt.indexOf('.') != -1) {
                var DigitsAfterDecimal = 2;
                var valIndex = Amt.indexOf(".");
                if (valIndex > "0") {
                    if (Amt.length - (Amt.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        $(Qty).val($(Qty).val().substring(0, ($(Qty).val().length - 1)));
                        return false;
                    }
                }
            }
            
            if (Amt == "") {
                $(Qty).val('0');
            }

            var scaleofCost = Number($.trim($(Qty).closest("tr").find("#tdScaleOfCost").text()));
            var FinalAmt = parseFloat(Amt) * parseFloat(scaleofCost);
            $(Qty).closest("tr").find("#tdFinalRate").text(FinalAmt.toFixed(2));
            var TotalAmt = 0, TotalActualAmt=0;
            //$("#tb_grdSurgerySearch").find("#txtRate").each(function () {
            //    if ($(this).val()!="")
            //        TotalAmt = parseFloat(TotalAmt) + parseFloat(Number($(this).val()));
            //});

            $("#tb_grdSurgerySearch").find("#tdFinalRate").each(function () {
                if ($(this).text() != "")
                    TotalAmt = parseFloat(TotalAmt) + parseFloat(Number($(this).text()));
            });

            $("#tb_grdSurgerySearch").find("#tdTotal").html(TotalAmt.toFixed(2));

            $("#tb_grdSurgerySearch").find("#txtRate").each(function () {
                if ($(this).val() != "")
                    TotalActualAmt = parseFloat(TotalActualAmt) + parseFloat(Number($(this).val()));
            });

            $("#tb_grdSurgerySearch").find("#tdActualTotal").html(TotalActualAmt.toFixed(2));
        }
    </script>
</asp:Content>

