<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Bank.aspx.cs" Inherits="Design_EDP_Bank_Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/Search.js"> </script>
     <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script  src="../../Scripts/json2.js" type="text/javascript"></script>
   <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Bank Master</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <div style="text-align: center; display:none;">
            <input id="rdoNew" type="radio" name="Con" value="New"  />New
            <input id="rdoEdit" type="radio" name="Con" value="Edit" checked="checked" />Edit    
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 15%; text-align: right">Name :&nbsp;
                    </td>
                    <td style="width: 10%; text-align: left">
                        <input type="text" id="txtName" class="requiredField" tabindex="1" maxlength="50" title="Enter Name" style="width: 250px" />
                    </td>
                    <td style="width: 15%; text-align: right;" >
                        Bank Cut (%) :&nbsp;
                    </td>
                    <td style=" text-align: left;">
                      <input type="text" id="txtBankCutPercentage" tabindex="1"  title="Enter Bank Cut Percentage" onlynumber="7" decimalplace="4" max-value="100" value="0" style="width: 100px" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right;display:none" class="trCondition">Condition :&nbsp;
                    </td>
                    <td style="text-align: left;display:none" class="trCondition">
                       <input id="rdoActive" type="radio" name="ActiveCon" value="1" checked="checked" />Active
                        <input id="rdoDeActive" type="radio" name="ActiveCon" value="0" />DeActive  
                         <input id="rdoBoth" type="radio" name="ActiveCon" value="2" />Both 

                    </td>
                     <td style="text-align: right;" >
                    </td>
                    <td style=" text-align: left;">
                      

                    </td>
                </tr>
                </table>

        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" value="Save" tabindex="5" class="ItDoseButton" />
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center">
         <div id="bankOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
             <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" style="display:none"/>
             </div>
    </div>
    <script type="text/javascript">
        function chkActiveCon(rowid) {
            $("#spnErrorMsg").text('');
            var rdotdActive = $(rowid).closest('tr').find('#tdActive input[type=radio]:checked').val();
            var spnActive = $.trim($(rowid).closest('tr').find('#spnActive').html());
            if (rdotdActive != spnActive) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('1'));
            }
            else if (($.trim($(rowid).closest('tr').find('#spnBankNameCon').html()) == "1")) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
            }
            else {
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
                $(rowid).closest('tr').css("background-color", "transparent");
            }
        }
        function CheckBank(rowid) {
            $("#spnErrorMsg").text('');
            var txtBankName = $.trim($(rowid).closest('tr').find('#txtBankName').val());
            var spnBankName = $.trim($(rowid).closest('tr').find('#spnBankName').html());
            if ((txtBankName != spnBankName)) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnBankNameCon').html('1'));
            }
            else if (($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1")) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnBankNameCon').html('0'));
            }
            else {
                $.trim($(rowid).closest('tr').find('#spnBankNameCon').html('0'));
                $(rowid).closest('tr').css("background-color", "transparent");
            }
        }

        function CheckBankCut(rowid) {
            var txtBankCut = $.trim($(rowid).closest('tr').find('#txtBankCutPer').val());
            var spnBankCut = $.trim($(rowid).closest('tr').find('#spnBankCutPercentage').html());
            if ((txtBankCut != spnBankCut)) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnBankCutPercentageCon').html('1'));
            }
            else if (($.trim($(rowid).closest('tr').find('#spnBankCutPercentageCon').html()) == "1")) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnBankCutPercentageCon').html('0'));
            }
            else {
                $(rowid).closest('tr').css("background-color", "transparent");
                $.trim($(rowid).closest('tr').find('#spnBankCutPercentageCon').html('0'));
            }
        }
        function bindBank() {
            var type = "";
            if ($("#rdoActive").is(':checked'))
                type = "1";
            else if ($("#rdoDeActive").is(':checked'))
                type = "0";
            else
                type = "2";

            $.ajax({
                url: "services/EDP.asmx/bindBank",
                data: '{BankName:"' + $("#txtName").val() + '",Type:"' + type + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        BankData = jQuery.parseJSON(result.d);
                        if (BankData != null) {
                            var output = $('#tb_BankSearch').parseTemplate(BankData);
                            $('#bankOutput').html(output);
                            $('#bankOutput,#btnUpdate').show();
                            $('#btnSave').removeProp('disabled');

                        }
                    }
                    else {
                        $('#bankOutput').html();
                        $('#bankOutput,#btnUpdate').hide();
                        DisplayMsg('MM04', 'spnErrorMsg');
                        $('#btnSave').removeProp('disabled');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#bankOutput').html();
                    $('#bankOutput').hide();
                    DisplayMsg('MM05', 'spnErrorMsg');
                }
            });
        }
        $(function () {
            if ($("#rdoNew").is(':checked')) {
                $("#btnSave").val('Save');
            }
            if ($("#rdoEdit").is(':checked')) {
                $("#btnSave").val('Search');
                $(".trCondition").show();
                $("#spnErrorMsg").text('');
                hideAllDetail();
            }

            $("#rdoNew").bind("click", function () {
                $("#btnSave").val('Save');
                $(".trCondition").hide();
                $("#spnErrorMsg").text('');
                hideAllDetail();
            });
            $("#rdoEdit").bind("click", function () {
                $("#btnSave").val('Search');
                $(".trCondition").show();
                $("#spnErrorMsg").text('');
                hideAllDetail();
            });
            $("#btnSave").bind("click", function () {
                $("#spnErrorMsg").text('');
                $('#btnSave').attr('disabled', 'disabled');
                if ($("#btnSave").val() == "Search") {
                    bindBank();
                }
                else if ($("#btnSave").val() == "Save") {
                    saveBank();
                }
            });
        });

        function hideAllDetail() {
            $('#bankOutput').html('');
            $('#bankOutput,#btnUpdate').hide();

        }
    </script>
            <script id="tb_BankSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdBankSearch"
    style="width:700px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">Bank_ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Name</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Bank Cut</th>        
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;">Active</th>
		</tr>
        <#       
        var dataLength=BankData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = BankData[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdBank_ID"  style="width:40px;display:none" ><#=objRow.Bank_ID#></td>                  
                    <td class="GridViewLabItemStyle" id="tdBankName" style="width:200px;">
                       <input type="text" maxlength="50" style="width:280px" value="<#=objRow.BankName#>" id="txtBankName" disabled="true" onkeyup="CheckBank(this);" onkeypress="CheckBank(this);"/>
                       <span style="color: red; font-size: 10px;" class="shat">*</span>
                       <span id="spnBankName" style="display:none" ><#=objRow.BankName#> </span>
                       <span id="spnBankNameCon"  style="display:none" /></td>  
                    <td class="GridViewLabItemStyle" id="tdBankCutPercentage"  style="width:100px;"> 
                         <input type="text" id="txtBankCutPer" onlynumber="7" decimalplace="4" max-value="100" onkeypress="$commonJsNumberValidation(event)" onkeyup="CheckBankCut(this);" onkeydown="$commonJsPreventDotRemove(event)" style="width:98px" value="<#=objRow.BankCutPercentage#>"  />
                          <span id="spnBankCutPercentage" style="display:none" ><#=objRow.BankCutPercentage#></span>
                          <span id="spnBankCutPercentageCon" style="display:none" />
                          </td>                                       
                    <td class="GridViewLabItemStyle" id="tdActive"  style="width:60px;display:none;">
                   <input type="radio" id="rdotdActive" name="tdActive_<#=j+1#>" value="1"
                      onclick="chkActiveCon(this)" <#if(objRow.IsActive=="1"){#> 
                        checked="checked"  <#} #> />Yes                         
                         <input type="radio" id="rdotdDeActive" name="tdActive_<#=j+1#>" value="0"
                        onclick="chkActiveCon(this)" <#if(objRow.IsActive=="0"){#> 
                        checked="checked"  <#} #>  />No                                               
                        <span id="spnActive" style="display:none"><#=objRow.IsActive#></span>
                         <span id="spnActiveCon" style="display:none"   />
                    </td>
                    </tr>           
        <#}#>                     
     </table>    
    </script>
    <script type ="text/javascript">
        $(function () {
            $("#btnUpdate").bind("click", function () {
                $('#btnUpdate').attr('disabled', 'disabled');
                if (validateBankUpdate() == true) {
                    var resultBankUpdate = bankUpdate();
                    $.ajax({
                        url: "Services/EDP.asmx/UpdateBank",
                        data: JSON.stringify({ Data: resultBankUpdate }),
                        type: "Post",
                        contentType: "application/json; charset=utf-8",
                        timeout: "120000",
                        dataType: "json",
                        success: function (result) {
                            if (result.d == "1") {
                                DisplayMsg('MM02', 'spnErrorMsg');
                                $('#btnUpdate').removeAttr('disabled');
                                $('#BankOutput').html('');
                                $('#BankOutput,#btnUpdate,.trCondition').hide();
                                $('#rdoActive').prop('checked', 'checked');
                                $('#rdoNew').prop('checked', 'checked');
                                $("#btnSave").val('Save');
                                hideAllDetail();
                            }
                            else if (result.d == "2") {
                                $("#spnErrorMsg").text('Bank Already Exist');
                                $('#btnUpdate').removeAttr('disabled');
                            }
                            else {
                                DisplayMsg('MM05', 'spnErrorMsg');
                            }

                        },
                        error: function (xhr, status) {
                            DisplayMsg('MM05', 'spnErrorMsg');
                        }
                    });
                }
                else {
                    $('#btnUpdate').removeProp('disabled');
                }
            });

        });
        function bankUpdate() {
            if ($('#tb_grdBankSearch tr').length > 0) {
                var con = 0;
                // $('#btnUpdate').prop('disabled', 'disabled');
                var dataItem = new Array();
                var ObjItem = new Object();
                $("#tb_grdBankSearch tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "Header") {
                        if (($.trim($rowid.find('#spnBankNameCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1") || ($.trim($rowid.find('#spnBankCutPercentageCon').html()) == "1")) {
                            ObjItem.BankName = $.trim($rowid.find("#txtBankName").val());
                            ObjItem.BankID = $.trim($rowid.find("#tdBank_ID").text());
                            ObjItem.BankCutPer = $.trim($rowid.find("#txtBankCutPer").val());
                            if ($rowid.find("#rdotdActive").is(':checked'))
                                ObjItem.IsActive = "1";
                            else
                                ObjItem.IsActive = "0";

                            dataItem.push(ObjItem);
                            ObjItem = new Object();
                        }
                    }

                });
                return dataItem;
            }
        }
        function validateBankUpdate() {
            var con = 0; var tableCon = 1;
            $("#tb_grdBankSearch tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header") {
                    if (($.trim($rowid.find('#spnBankNameCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1") || ($.trim($rowid.find('#spnBankCutPercentageCon').html()) == "1")) {
                        if ($.trim($rowid.find("#txtBankName").val()) == "") {
                            $("#spnErrorMsg").text('Please Enter Bank Name');
                            $rowid.find("#txtBankName").focus();
                            con = 1;
                            return false;
                        }
                        tableCon += 1;
                    }
                }

            });
            if (con == "1")
                return false;
            if (tableCon == "1") {
                $("#spnErrorMsg").text('Please Change Bank Name OR Active or Bank Cut (%) Condition');
                return false;
            }
            return true;
        }
        function saveBank() {
            if (validateBank() == true) {

                $.ajax({
                    url: "Services/EDP.asmx/SaveBank",
                    data: '{BankName:"' + $.trim($('#txtName').val()) + '",BankcutPer:"' + $.trim($('#txtBankCutPercentage').val()) + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    cache: false,
                    success: function (result) {
                        if (result.d == "1") {
                            $("#spnErrorMsg").text('Record Saved Successfully');
                            $('#txtName').val('');
                            $('#txtBankCutPercentage').val('0');
                            $("#btnSave").removeProp('disabled');
                        }
                        else if (result.d == "2") {
                            $("#spnErrorMsg").text('Bank Already Exist');
                            $('#txtName').focus();
                            $("#btnSave").removeProp('disabled');
                        }

                        else {
                            DisplayMsg('MM05', 'spnErrorMsg');
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'spnErrorMsg');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            else {
                $('#btnSave').removeProp('disabled');
            }
        }

        function validateBank() {
            if ($.trim($('#txtName').val()) == "") {
                $("#spnErrorMsg").text('Please Enter Bank Name');
                $('#txtName').focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>

