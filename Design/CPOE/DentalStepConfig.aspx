<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DentalStepConfig.aspx.cs" Inherits="Design_CPOE_DentalStepConfig" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
     <Ajax:ScriptManager ID="sc1" runat="server"></Ajax:ScriptManager>
    <div id="Pbody_box_inventor">
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="text-align:center;">
                  <b>Dental Procedure configration</b><br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <table>
                <tr>
                    <td>Procedure :&nbsp;</td>
                    <td><select id="dllProcedure" onchange="BindAllProcedure();" style="width:225px;"></select></td>
                     <td>Duration :&nbsp;</td>
                     <td><input type="text" id="txtDuration" style="width:75px;" placeholder="Enter total Duration"/></td>
                     <td>No Of step :&nbsp;</td>
                     <td><input type="text" id="txtStep" style="width:75px;" placeholder="Enter No Of step"/></td>
                     <td><input type="button" value="Set" id="btnSet" onclick="SetPro();" class="ItDoseButton" /> </td>
                     <td><input type="button" value="Create New Step" id="btnNewStep" onclick="ShowStepMaster();" class="ItDoseButton" /> </td>
                    <td><span style="width:275px;color:red;font-size:14px;font-weight:800;text-align:right;" id="spRate" ></span></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <table class="GridViewStyle" id="GridView">
                <thead>
                    <tr>
                        <td class="GridViewHeaderStyle">Step</td>
                         <td class="GridViewHeaderStyle">Day</td>
                         <td class="GridViewHeaderStyle">Sequence</td>
                         <td class="GridViewHeaderStyle">Rate in Amt</td>
                         <td class="GridViewHeaderStyle">Rate in Per(%)</td>
                    </tr>
                </thead>
                <tbody id="tbStep" class=""></tbody>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center;">
           <input type="button" value="Save" id="btnSave" onclick="SaveProcedure();" class="ItDoseButton" />
        </div>
        <cc2:ModalPopupExtender ID="mpopStep" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        PopupDragHandleControlID="dragHandle" CancelControlID="btnCancelstep" Drag="true"  PopupControlID="pnlStep"
        TargetControlID="btn1" X="150" Y="100" BehaviorID="mpopStep" OnCancelScript="">
    </cc2:ModalPopupExtender>
          <asp:Panel ID="pnlStep" runat="server" Width="340px"   CssClass="pnlItemsFilter" Style="display: none;">
             <div class="Purchaseheader">
           Step Master &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span><em onclick="closeM();" style="font-size:10px;">Press esc to <span style="color:red;">&times;</span> close</em></span>
        </div>
            <div  style="width:440px;">
                
                <table>
                    <tr>
                        <td>
                            Step Name :&nbsp;
                        </td>
                         <td>
                           <input type="text" id="txtStepName" />
                             <span id="spID" style="display:none;" ></span>
                        </td>
                    </tr>
                    <tr>
                         <td>
                            IsActive:&nbsp;
                        </td> 
                         <td>
                           <input type="radio" checked="checked" id="rblYes" name="IsActive" value="Yes"/>
                             <input type="radio" id="rblNo" name="IsActive" value="NO"/>
                        </td>
                    </tr>
                </table>
            </div>
               <div  style="text-align:center;">
                    <input type="button" value="Save" id="btnSaveStep" onclick="SaveStep();" class="ItDoseButton" />
                   <input type="button" value="Close" id="btnCloseStep" onclick="closeM();" class="ItDoseButton" />
            </div>
              <div>
               <div id="divStepMaster">
               </div>
              </div>
        </asp:Panel>
        <div style="display: none;">
        <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton"/>
        <asp:Button ID="btnCancelstep" runat="server" CssClass="ItDoseButton"/>
    </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#GridView').hide();
            $('#btnSave').hide();
            BindProcedure();
            ShowStep();
        });
        function closeM(){
            if ($find("mpopStep")) {
                $find("mpopStep").hide();
            }
        }
        function ShowStepMaster() {
            $find("mpopStep").show();
        }
        function SaveStep() {
            var Status = 0;
            if ($('#rblYes').is(':checked')) {
                Status = 1;
            }
            if ($('#txtStepName').val() == '')
            {
                alert('Please Enter Step Name');
                return;
            }
            $.ajax({
                url: 'Services/Dental_Services.asmx/SaveStemMaster',
                data: '{StepName:"' + $('#txtStepName').val() + '",ID:"' + $('#spID').text() + '",Status:"'+Status+'"}',
                dataType: 'JSON',
                contentType: 'application/json; charset=utf-8',
                type: 'POST',
                success: function (res) {
                    if (res.d == "1") {
                        alert('Saved Successfully');
                        ShowStep();
                        $('#spID').text('');
                        $('#btnSaveStep').val('Save');
                    }
                    else if (res.d == "2") {
                        alert('Same Step Exist');
                    }
                    else { alert('Error..'); }
                },
                error: function () { }
            });
        }
        function BindProcedure() {
            $.blockUI({ message: 'Please Wait.....\n<img src="../../Images/loadingAnim.gif" />' });
            $.ajax({
                url: 'Services/Dental_Services.asmx/BindProcedure',
                data: '',
                dataType: 'JSON',
                contentType: 'application/json; charset=utf-8',
                type: 'POST',
                success: function (res) {
                    if (res.d != "") {
                        ProData = JSON.parse(res.d);
                        $('#dllProcedure').append($('<option></option>').val(0).text('..Select..'));
                        for (var i = 0; i < ProData.length; i++)
                        {
                            $('#dllProcedure').append($('<option></option>').val(ProData[i].ItemID).text(ProData[i].TypeName));
                        }
                    }
                    else { $('#spnErrorMsg').text('Error..'); }
                },
                error: function () { }
            });
            $.unblockUI();
        }
        function SetPro() {
            if ($('#dllProcedure').val() == 0) {
                $('#spnErrorMsg').text('Please select procedure');
                return ;
            }
            if ($('#txtDuration').val() == '') {
                $('#spnErrorMsg').text('Please enter duration');
                return;
            }
            if ($('#txtStep').val() == '') {
                $('#spnErrorMsg').text('Please enter duration');
                return;
            }
            BildGrid();
        }
        function BildGrid() {
            var TotalStep = 0;
            $('#tbStep tr').remove();
            if ($('#txtStep').val() != "") {
                TotalStep = $('#txtStep').val();
                for (var i = 0; i < TotalStep; i++) {
                    var Row = " <tr> <td class='GridViewItemStyle'><select id='ddlStep' onchange='validateStep(this);' class='ddlStep'></select></td>" +
                            " <td class='GridViewItemStyle'><input type='text' id='txtDay'/></td>" +
                            " <td class='GridViewItemStyle'><input type='text' value='" + (i + 1) + "' id='txtSeq'/></td>" +
                            " <td class='GridViewItemStyle'><input type='text' onkeyup='PerOrAmount(this);calculateAmount(this)' id='txtRateInAmt'/></td>" +
                            " <td class='GridViewItemStyle'><input type='text' onkeyup='CheckForPercentage(this);PerOrAmount(this);calculateAmount(this)' id='txtRateInper'/></td><td id='tdSnID' style='display:none;'>" + (i + 1) + "</td> </tr> ";
                    $('#tbStep').append(Row);
                }
            }
            else {
                TotalStep = StepMasterData.length;
                for (var i = 0; i < TotalStep; i++) {
                    var Row = " <tr> <td class='GridViewItemStyle'><select id='ddlStep' onchange='validateStep(this);' class='ddlStep'></select></td>" +
                            " <td class='GridViewItemStyle'><input type='text' value='" + StepMasterData[i].Day + "' id='txtDay'/></td>" +
                            " <td class='GridViewItemStyle'><input type='text' value='" + StepMasterData[i].SeqNo + "' id='txtSeq'/></td>" +
                            " <td class='GridViewItemStyle'><input type='text' onkeyup='PerOrAmount(this);calculateAmount(this)' value='" + StepMasterData[i].Amount + "' id='txtRateInAmt'/></td>" +
                            " <td class='GridViewItemStyle'><input type='text' onkeyup='CheckForPercentage(this);PerOrAmount(this);calculateAmount(this)' value='" + StepMasterData[i].Per + "' id='txtRateInper'/></td><td id='tdSnID' style='display:none;'>" + (i + 1) + "</td>" +
                            "<td id='tdStepId' style='display:none;'>" + StepMasterData[i].StepID + "</td></tr> ";

                    $('#tbStep').append(Row);
                }
            }
          
           
            if (TotalStep > 0) {
                $('#GridView').show();
                $('#btnSave').show();
                BindStep();
            }
            else {
                $('#GridView').hide();
                $('#btnSave').hide();
            }
        }
        function CheckForPercentage(sender) {
            $('#spnErrorMsg').text('');
            if (parseFloat(sender.value) > 100) {
                $('#spnErrorMsg').text('Percentage Share must be less than 100');
                sender.value = 0;
                return;
            }
        }
        function PerOrAmount(sender) {
            if (sender.id == 'txtRateInAmt') {
                $(sender).closest('tr').find('#txtRateInper').val(0);
            }
            else { $(sender).closest('tr').find('#txtRateInAmt').val(0); }
        }
        function validateStep(RowId) {
            $('#spnErrorMsg').text('');
            $('#tbStep tr').each(function () {
                if ($(RowId).closest('tr').find('#tdSnID').text() != $(this).closest('tr').find('#tdSnID').text()) {
                    if ($(RowId).closest('tr').find('#ddlStep').val() == $(this).closest('tr').find('#ddlStep').val()) {
                        $('#spnErrorMsg').text($(RowId).closest('tr').find('#ddlStep :selected').text() + ' Is already Selected in another Step');
                        return;
                    }
                }
            });
        }
        function BindAllProcedure() {
            $('#spnErrorMsg').text('');
            $.blockUI({ message: 'Please Wait.....\n<img src="../../Images/loadingAnim.gif" />' });
            LoadRate();
            $.ajax({
                url: 'Services/Dental_Services.asmx/BindStepMaster',
                data: '{ItemId:"' + $('#dllProcedure').val() + '"}',
                dataType: 'JSON',
                contentType: 'application/json; charset=utf-8',
                type: 'POST',
                success: function (res) {
                    if (res.d != "") {
                        StepMasterData = JSON.parse(res.d);
                        BildGrid();
                        $('#txtDuration').attr('disabled', 'disabled');
                        $('#txtStep').attr('disabled', 'disabled');
                        $('#btnSet').attr('disabled', 'disabled');
                        $.unblockUI();
                    }
                    else {
                        //$('#spnErrorMsg').text('Error..');
                        StepMasterData = "";
                        $('#txtDuration').removeAttr('disabled');
                        $('#txtStep').removeAttr('disabled');
                        $('#btnSet').removeAttr('disabled');
                        BildGrid();
                        $.unblockUI();
                    }
                },
                error: function () { $('#spnErrorMsg').text('Error..'); $.unblockUI(); }
            });
          
        }
        function BindStep() {
            $.ajax({
                url: 'Services/Dental_Services.asmx/BindStep',
                data: '',
                dataType: 'JSON',
                contentType: 'application/json; charset=utf-8',
                type: 'POST',
                success: function (res) {
                    if (res.d != "") {
                        ProData = JSON.parse(res.d);
                        $('.ddlStep').append($('<option></option>').val(0).text('..Select..'));
                        for (var i = 0; i < ProData.length; i++) {
                            if (ProData[i].IsActive == '1') {
                                $('.ddlStep').append($('<option></option>').val(ProData[i].ID).text(ProData[i].Name));
                            }
                        }
                        if (StepMasterData.length > 0)
                        {
                            $('#tbStep tr').each(function () {
                                for (var i = 0; i < StepMasterData.length; i++) {
                                    if (StepMasterData[i].StepID == $(this).closest('tr').find('#tdStepId').text()) {
                                        $(this).closest('tr').find('#ddlStep').val(StepMasterData[i].StepID);
                                    }
                                }
                            });

                        }
                    }
                    else { $('#spnErrorMsg').text('Error..'); }
                },
                error: function () { }
            });
        }
        function SaveProcedure() {
                var DataList = new Array;
                if (validatePro()) {
                    $.blockUI({ message: 'Please Wait.....\n<img src="../../Images/loadingAnim.gif" />' });
                    $('#tbStep tr').each(function () {
                        var data = new Object;
                        data.ItemID = $('#dllProcedure').val();
                        data.StepID = $(this).closest('tr').find('#ddlStep').val();
                        data.SeqNo = $(this).closest('tr').find('#txtSeq').val();
                        data.Per = $(this).closest('tr').find('#txtRateInper').val();
                        data.Amount = $(this).closest('tr').find('#txtRateInAmt').val();
                        data.Day = $(this).closest('tr').find('#txtDay').val();
                        DataList.push(data);
                    });
                    $.ajax({
                        url: 'Services/Dental_Services.asmx/SaveStep',
                        data: JSON.stringify({ ProData: DataList }),
                        dataType: 'JSON',
                        contentType: 'application/json; charset=utf-8',
                        type: 'POST',
                        success: function (res) {
                            if (res.d == "1") {
                                $('#spnErrorMsg').text('Saved Successfully');
                                 $.unblockUI();
                            }
                            else { $('#spnErrorMsg').text('Error..');  $.unblockUI();}
                        },
                        error: function () { $('#spnErrorMsg').text('Error..'); $.unblockUI(); }
                    });
                   
                }
            }
        function validatePro() {
            var TotalPer = 0;
            var TotalPrice = 0;
            if ($('#dllProcedure').val() == 0) {
                $('#spnErrorMsg').text('Please select procedure');
                return false;
            }
                $('#tbStep tr').each(function () {
                    //if (parseFloat($(this).closest('tr').find('#txtRateInper').val()) != 0 && parseFloat($(this).closest('tr').find('#txtRateInAmt').val()) != 0)
                    //{
                    //    $('#spnErrorMsg').text('Please Enter Amount or Percentage, not both');
                    //    $(this).closest('tr').find('#txtRateInper').val(0);
                    //    $(this).closest('tr').find('#txtRateInAmt').val(0);
                    //    return false;
                    //}
                    if (parseFloat($(this).closest('tr').find('#txtRateInper').val()) == 0 && parseFloat($(this).closest('tr').find('#txtRateInAmt').val()) == 0) {
                        $('#spnErrorMsg').text('Please Enter Rate');
                        $(this).closest('tr').find('#txtRateInper').val(0);
                        $(this).closest('tr').find('#txtRateInAmt').val(0);
                        return false;
                    }
                    if (parseInt($(this).closest('tr').find('#txtSeq').val()) == 0 || $(this).closest('tr').find('#txtSeq').val() == '') {
                        $('#spnErrorMsg').text('Please Set Sequence');
                        $(this).closest('tr').find('#txtSeq').val(0);
                        return false;
                    }
                    if (parseInt($(this).closest('tr').find('#txtDay').val()) == 0 || $(this).closest('tr').find('#txtDay').val() == '') {
                        $('#spnErrorMsg').text('Please Set Day');
                        $(this).closest('tr').find('#txtDay').val(0);
                        return false;
                    }
                    if ($(this).closest('tr').find('#txtRateInper').val() != '') {
                        TotalPer = TotalPer + parseFloat($(this).closest('tr').find('#txtRateInper').val());
                    }
                    if ($(this).closest('tr').find('#txtRateInAmt').val() != '') {
                        TotalPrice = TotalPrice + parseFloat($(this).closest('tr').find('#txtRateInAmt').val());
                    }
                });
                if (TotalPer > 100)
                {
                    $('#spnErrorMsg').text('Sum of All per% should be 100 or less it');
                   
                    return false;
                }
                if (TotalPrice > parseFloat($('#spRate').text().split(':')[1])) {
                    $('#spnErrorMsg').text('Sum of amount should be equal to ' + $('#spRate').text().split(':')[1] + ' or less it');

                    return false;
                }
                return true;
         }
         function ShowStep() {
             $.ajax({
                 url: 'Services/Dental_Services.asmx/BindStep',
                 data: '',
                 dataType: 'JSON',
                 contentType: 'application/json; charset=utf-8',
                 type: 'POST',
                 success: function (res) {
                     if (res.d != "") {
                         StepData = JSON.parse(res.d);
                         if (StepData != null)
                         {
                             var output = $("#scStepMaster").parseTemplate(StepData);
                             $("#divStepMaster").html(output);
                             $("#divStepMaster").show();
                         }
                     }
                 }
             });
         }
         function LoadRate() {
             $.ajax({
                 url: 'Services/Dental_Services.asmx/LoadRate',
                 data: '{ItemId:"' + $('#dllProcedure').val() + '"}',
                 dataType: 'JSON',
                 contentType: 'application/json; charset=utf-8',
                 type: 'POST',
                 success: function (res) {
                     if (res.d != "") {
                         ProRate = JSON.parse(res.d);
                         if (ProRate != null) {
                             $('#spRate').text('  Rate :'+ ProRate[0].Rate);
                         }
                     }
                     else {
                         $('#spnErrorMsg').text('Rate Not Set.Please contact administrator');
                         $('#spRate').text('');
                     }
                 }
             });
         }
         function EditStep(rowId) {
             $('#txtStepName').val($(rowId).closest('tr').find('#tdStepName').text());
             $('#spID').text($(rowId).closest('tr').find('#tdStepId').text());
             if ($(rowId).closest('tr').find('#tdStepStatus').text() == 'Active')
             {
                 $('#rblYes').attr('checked', 'checked');
             }
             else
             { $('#rblNo').attr('checked', 'checked'); }
             $('#btnSaveStep').val('Update');
         }
         function calculateAmount(rowID) {
             var Amount = $(rowID).closest('tr').find('#txtRateInAmt').val();
             var Percetage = $(rowID).closest('tr').find('#txtRateInper').val();
             var rate = parseFloat($('#spRate').text().split(':')[1]);
             if (parseFloat(Amount) > 0) {
                 if (parseFloat(Amount) > parseFloat(rate))
                 {
                     $('#spnErrorMsg').text('Amount should be less than rate ');
                     $(rowID).closest('tr').find('#txtRateInAmt').val(0);
                     return ;
                 }
                 var calPer = (100 / parseFloat(rate)) * parseFloat(Amount);
                 $(rowID).closest('tr').find('#txtRateInper').val(calPer);
             } else {
                 if (parseFloat(Percetage) > 100) {
                     $('#spnErrorMsg').text('Amount should be less than rate ');
                     $(rowID).closest('tr').find('#txtRateInper').val(0);
                     return;
                 }
                 var CalAmt = (parseFloat(rate) * parseFloat(Percetage)) / 100;
                 $(rowID).closest('tr').find('#txtRateInAmt').val(CalAmt);
             }
         }
        function ValidateSeq(rowId)
        {
        
        }
        function validateDay(rowId){
            if($('#txtDuration').val()!='')
             {
            if(parseFloat($('#txtDuration').val())<parseFloat(rowId.value))
             {
                  $('#spnErrorMsg').text('Day should be less than or equal to Duration ');
                rowId.value='';
                return;
            }
           }
        }
    </script>
    <script id="scStepMaster" type="text/html">
        <table class="GridViewStyle" width="100%">
            <thead>
                <tr>
                    <td class="GridViewHeaderStyle">S.N.</td>
                    <td class="GridViewHeaderStyle">Step Name</td>
                    <td class="GridViewHeaderStyle">Status</td>
                     <td class="GridViewHeaderStyle">Edit</td>
                </tr>
            </thead>
            <tbody id="tbStepMaster">
                 <#
                  var dataLength=StepData.length;
                var count=0;
                window.status="Total Records Found :"+ dataLength;
                var objRow;
                for(var j=0;j<dataLength;j++)
                {
                    objRow = StepData[j];
                    #>
                <tr>
                    <td class="GridViewItemStyle"><#=(j+1)#></td>
                    <td class="GridViewItemStyle" id="tdStepName"><#=objRow.Name#></td>
                    <td class="GridViewItemStyle" id="tdStepStatus"><#if(objRow.IsActive==1){#>Active<#}else{#>Deactive<#}#></td>
                    <td class="GridViewItemStyle" ><img src="../../Images/edit.png" onclick="EditStep(this);"></td>
                    <td style="display:none;" id="tdStepId"><#=objRow.ID#></td>
                </tr>
                   <# }#>
            </tbody>
        </table>
    </script>
</asp:Content>

