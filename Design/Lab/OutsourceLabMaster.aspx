<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OutsourceLabMaster.aspx.cs" Inherits="Design_Lab_OutsourceLabMaster" MasterPageFile="~/DefaultHome.master" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script  src="../../Scripts/json2.js" type="text/javascript"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;"> 
            <b>OutSource Lab Master</b>
            <br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <div style="text-align: center">
                <input id="rdoNew" type="radio" name="Con" value="New" checked="checked" />New
            <input id="rdoEdit" type="radio" name="Con" value="Edit" />Edit    
            </div>
        </div>



        <div class="POuter_Box_Inventory">
            <div class="col-md-24">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">OutSource Lab</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5"> <input type="text" id="txtName" tabindex="1" data-title="Enter Lab Name" class="required" autocomplete="off"  /></div>

                    <div class="col-md-3">
                        <label class="pull-left">Contact Person</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5"> <input type="text" id="txtContactPerson" tabindex="2" data-title="Enter Contact Person" class="required" autocomplete="off" /></div>

                    <div class="col-md-3">
                        <label class="pull-left">Address</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">  <asp:TextBox ID="txtAddress" runat="server" ClientIDMode="Static"  TabIndex="3" AutoCompleteType="Disabled" ></asp:TextBox></div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Contact No.</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5"> 
                        <asp:TextBox ID="txtContactNo" runat="server" TabIndex="4" data-title="Enter Contact No." AutoCompleteType="Disabled" CssClass="required" MaxLength="11" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbContactNo" runat="server" TargetControlID="txtContactNo" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="trCondition">
                    <div class="col-md-3">
                        <label class="pull-left">Status</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">   <input id="rdoActive" type="radio" name="ActiveCon" value="1" checked="checked" />Active
                        <input id="rdoDeActive" type="radio" name="ActiveCon" value="0" />DeActive</div>
                        </div>
                    <div class="col-md-3">
                        <label class="pull-right"></label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-5"> </div>
                </div>
                </div>
        </div>
       

        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" value="Save" tabindex="5" class="ItDoseButton" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
         <div id="OutSourceLabOutput" style="max-height: 500px; overflow-x: auto;">
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
         else if (($.trim($(rowid).closest('tr').find('#spnNameCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnContactPersonCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnAddressCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnMobileNoCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
         }
         else {
             $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
             $(rowid).closest('tr').css("background-color", "transparent");
         }
     }
     function CheckName(rowid) {
         $("#spnErrorMsg").text('');
         var txtName = $.trim($(rowid).closest('tr').find('#txtLabName').val());
         var spnName = $.trim($(rowid).closest('tr').find('#spnName').html());
         if ((txtName != spnName)) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnNameCon').html('1'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnNameCon').html('0'));
         }
         
         else if (($.trim($(rowid).closest('tr').find('#spnContactPersonCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnNameCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnAddressCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnNameCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnMobileNoCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnNameCon').html('0'));
         }
         else {
             $.trim($(rowid).closest('tr').find('#spnNameCon').html('0'));
             $(rowid).closest('tr').css("background-color", "transparent");
         }
     }
     function CheckContactPerson(rowid) {
         $("#spnErrorMsg").text('');
         var ContactPerson = $.trim($(rowid).closest('tr').find('#txtOutContactPerson').val());
         var spnContactPerson = $.trim($(rowid).closest('tr').find('#spnContactPerson').html());
         if ((ContactPerson != spnContactPerson)) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnContactPersonCon').html('1'));
         }         
         else if (($.trim($(rowid).closest('tr').find('#spnNameCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnContactPersonCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnAddressCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnContactPersonCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnMobileNoCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnContactPersonCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnContactPersonCon').html('0'));
         }
         else {
             $.trim($(rowid).closest('tr').find('#spnContactPersonCon').html('0'));
             $(rowid).closest('tr').css("background-color", "transparent");
         }
     }
     
     function CheckAddress(rowid) {
         $("#spnErrorMsg").text('');
         var txtAddress = $.trim($(rowid).closest('tr').find('#txtOutAddress').val());
         var spnAddress = $.trim($(rowid).closest('tr').find('#spnAddress').html());
         if ((txtAddress != spnAddress)) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnAddressCon').html('1'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnNameCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnAddressCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnContactPersonCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnAddressCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnMobileNoCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnAddressCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnAddressCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnAddressCon').html('0'));
         }
         else {
             $.trim($(rowid).closest('tr').find('#spnAddressCon').html('0'));
             $(rowid).closest('tr').css("background-color", "transparent");
         }
     }

     function CheckContactNo(rowid) {
         $("#spnErrorMsg").text('');
         var txtContactNo = $.trim($(rowid).closest('tr').find('#txtOutContactNo').val());
         var spnContactNo = $.trim($(rowid).closest('tr').find('#spnContactNo').html());
         if ((txtContactNo != spnContactNo)) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnContactNoCon').html('1'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnNameCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnContactNoCon').html('0'));
         }
         else if (($.trim($(rowid).closest('tr').find('#spnContactPersonCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnContactNoCon').html('0'));
         }                       
         else if (($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1")) {
             $(rowid).closest('tr').css("background-color", "#FDE76D");
             $.trim($(rowid).closest('tr').find('#spnContactNoCon').html('0'));
         }
         else {
             $.trim($(rowid).closest('tr').find('#spnContactNoCon').html('0'));
             $(rowid).closest('tr').css("background-color", "transparent");
         }
     }
     function bindOutsource() {
         var type = "";
         if ($("#rdoActive").is(':checked'))
             type = "1";
         else if ($("#rdoDeActive").is(':checked'))
             type = "0";
         else
             type = "2";

         $.ajax({
             url: "OutsourceLabMaster.aspx/bindOutSourceLab",
             data: '{OutSourceLabName:"' + $("#txtName").val() + '",Type:"' + type + '",ContactPerson:"' + $("#txtContactPerson").val() + '",Address:"' + $("#txtAddress").val() + '",ContactNo:"' + $("#txtContactNo").val() + '" }',
             type: "POST",
             contentType: "application/json; charset=utf-8",
             timeout: 120000,
             async: true,
             dataType: "json",
             success: function (result) {
                 if (result.d != "") {
                     outsourceData = jQuery.parseJSON(result.d);
                     if (outsourceData != null) {
                         var output = $('#tb_OutsourceSearch').parseTemplate(outsourceData);
                         $('#OutSourceLabOutput').html(output);
                         $('#OutSourceLabOutput,#btnUpdate').show();
                         $('#btnSave').removeAttr('disabled');

                     }
                 }
                 else {
                     $('#OutSourceLabOutput').html();
                     $('#OutSourceLabOutput,#btnUpdate').hide();
                     modelAlert('Record Not Found');
                    // $("#spnErrorMsg").text('Record Not Found');
                     $('#btnSave').removeAttr('disabled');
                 }
             },
             error: function (xhr, status) {
                 $('#OutSourceLabOutput').html();
                 $('#OutSourceLabOutput').hide();
                 modelAlert('Error occurred, Please contact administrator');
                 //$("#spnErrorMsg").text('Error occurred, Please contact administrator');
             }
         });
     }
     $(function () {
         if ($("#rdoNew").is(':checked')) {
             $("#btnSave").val('Save');
         }
         if ($("#rdoEdit").is(':checked')) {
             $("#btnSave").val('Search');
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
                 bindOutsource();
             }
             else if ($("#btnSave").val() == "Save") {
                 saveOutsource();
             }
         });
     });

     function hideAllDetail() {
         $('#OutSourceLabOutput').html('');
         $('#OutSourceLabOutput,#btnUpdate').hide();

     }
    </script>
            <script id="tb_OutsourceSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdOutsourceSearch"
    style="width:1290px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;">Lab Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;">Contact Person</th>     
            <th class="GridViewHeaderStyle" scope="col" style="width:280px;">Address</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Contact No.</th>                          
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Active</th>
		</tr>
        <#       
        var dataLength=outsourceData.length;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = outsourceData[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdID"  style="width:40px;display:none" ><#=objRow.ID#></td>                  
                    <td class="GridViewLabItemStyle" id="tdName" style="width:220px;">
                       <input type="text" maxlength="50" style="width:250px" value="<#=objRow.Name#>" class="requiredField" id="txtLabName" onkeyup="CheckName(this);" onkeypress="CheckName(this);"/>
                       <span id="spnName" style="display:none" ><#=objRow.Name#> </span>
                       <span id="spnNameCon"  style="display:none" /></td>  
                        
                    <td class="GridViewLabItemStyle" id="tdContactPerson" style="width:220px;">
                       <input type="text" maxlength="50" style="width:250px" value="<#=objRow.ContactPerson#>" id="txtOutContactPerson" class="requiredField" onkeyup="CheckContactPerson(this);" onkeypress="CheckContactPerson(this);"/>
                       
                       <span id="spnContactPerson" style="display:none" ><#=objRow.ContactPerson#> </span>
                       <span id="spnContactPersonCon"  style="display:none" /></td>  
                        
                        
                        <td class="GridViewLabItemStyle" id="tdAddress" style="width:280px;">
                       <input type="text" maxlength="100" style="width:250px" value="<#=objRow.Address#>" id="txtOutAddress" onkeyup="CheckAddress(this);" onkeypress="CheckAddress(this);"/>
                       
                       <span id="spnAddress" style="display:none" ><#=objRow.Address#> </span>
                       <span id="spnAddressCon"  style="display:none" /></td>  
                        
                        
                        <td class="GridViewLabItemStyle" id="tdContactNo" style="width:120px;">
                       <input type="text" maxlength="11" style="width:250px" class="requiredField" value="<#=objRow.MobileNo#>" id="txtOutContactNo" onkeyup="CheckContactNo(this);" onkeypress="CheckContactNo(this);"/>
                       
                       <span id="spnContactNo" style="display:none" ><#=objRow.MobileNo#> </span>
                       <span id="spnContactNoCon"  style="display:none" /></td>      
                                                                  
                    <td class="GridViewLabItemStyle" id="tdActive"  style="width:120px;">
                   <input type="radio" id="rdotdActive" name="tdActive_<#=j+1#>" value="1"
                      onclick="chkActiveCon(this)"    <#if(objRow.Active=="1"){#> 
                        checked="checked"  <#} #> />Yes                         
                         <input type="radio" id="rdotdDeActive" name="tdActive_<#=j+1#>" value="0"
                        onclick="chkActiveCon(this)" <#if(objRow.Active=="0"){#> 
                        checked="checked"  <#} #>  />No                                               
                        <span id="spnActive" style="display:none"><#=objRow.Active#></span>
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
                if (validateOutsourceUpdate() == true) {
                    var resultOutsourceUpdate = OutsourceUpdate();
                    $.ajax({
                        url: "OutsourceLabMaster.aspx/UpdateOutSourceLab",
                        data: JSON.stringify({ Data: resultOutsourceUpdate }),
                        type: "Post",
                        contentType: "application/json; charset=utf-8",
                        timeout: "120000",
                        dataType: "json",
                        success: function (result) {
                            if (result.d == "1") {
                               // $("#spnErrorMsg").text('Record Updated Successfully');
                                modelAlert('Record Updated Successfully');
                                $('#btnUpdate').removeAttr('disabled');
                                $('#OutSourceLabOutput').html('');
                                $('#OutSourceLabOutput,#btnUpdate,.trCondition').hide();
                                $('#rdoActive').prop('checked', 'checked');
                                $('#rdoNew').prop('checked', 'checked');
                                $("#btnSave").val('Save');
                                hideAllDetail();
                            }
                            else if (result.d == "2") {
                               // $("#spnErrorMsg").text('Name Already Exist');
                                modelAlert('Name Already Exist')
                                $('#btnUpdate').removeAttr('disabled');
                            }
                            else {
                              //  $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                                modelAlert('Error occurred, Please contact administrator');
                            }

                        },
                        error: function (xhr, status) {
                            // $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                            modelAlert('Error occurred, Please contact administrator');

                        }
                    });
                }
                else {
                    $('#btnUpdate').removeProp('disabled');
                }
            });

        });
        function OutsourceUpdate() {
            if ($('#tb_grdOutsourceSearch tr').length > 0) {
                var con = 0;
                // $('#btnUpdate').prop('disabled', 'disabled');
                var dataItem = new Array();
                var ObjItem = new Object();
                $("#tb_grdOutsourceSearch tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "Header") {
                        if (($.trim($rowid.find('#spnNameCon').html()) == "1") || ($.trim($rowid.find('#spnContactPersonCon').html()) == "1") || ($.trim($rowid.find('#spnAddressCon').html()) == "1") || ($.trim($rowid.find('#spnContactNoCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html())=="1")) {
                            ObjItem.Name = $.trim($rowid.find("#txtLabName").val());
                            ObjItem.ContactPerson = $.trim($rowid.find("#txtOutContactPerson").val());
                            ObjItem.Address = $.trim($rowid.find("#txtOutAddress").val());
                            ObjItem.MobileNo = $.trim($rowid.find("#txtOutContactNo").val());
                            ObjItem.OutsourceLabID = $.trim($rowid.find("#tdID").text());
                            if ($rowid.find("#rdotdActive").is(':checked'))
                                ObjItem.Active = "1";
                            else
                                ObjItem.Active = "0";

                            dataItem.push(ObjItem);
                            ObjItem = new Object();
                        }
                    }

                });
                return dataItem;
            }
        }
        function validateOutsourceUpdate() {
            var con = 0; var tableCon = 1;
            $("#tb_grdOutsourceSearch tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header") {
                    if (($.trim($rowid.find('#spnNameCon').html()) == "1") || ($.trim($rowid.find('#spnContactPersonCon').html()) == "1") || ($.trim($rowid.find('#spnAddressCon').html()) == "1") || ($.trim($rowid.find('#spnContactNoCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1")) {
                        if ($.trim($rowid.find("#txtLabName").val()) == "") {
                            $("#spnErrorMsg").text('Please Enter Lab Name');
                            $rowid.find("#txtLabName").focus();
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
                modelAlert('Please Change Name OR OR Contact Person OR Address OR Contact No. OR Active Condition');
//  $("#spnErrorMsg").text('Please Change Name OR OR Contact Person OR Address OR Contact No. OR Active Condition');
                return false;
            }
            return true;
        }
        function saveOutsource() {
            if (validateOutsource() == true) {

                $.ajax({
                    url: "OutsourceLabMaster.aspx/SaveOutSourceLab",
                    data: '{Name:"' + $.trim($('#txtName').val()) + '",ContactPerson:"' + $.trim($('#txtContactPerson').val()) + '",ContactNo:"' + $.trim($('#txtContactNo').val()) + '",Address:"' + $.trim($('#txtAddress').val()) + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    cache: false,
                    success: function (result) {
                        if (result.d == "1") {
                            //  $("#spnErrorMsg").text('Record Saved Successfully');
                            modelAlert('Record Saved Successfully');
                            $('#txtName,#txtContactPerson,#txtContactNo,#txtAddress').val('');                           
                        }
                        else if (result.d == "2") {
                          //  $("#spnErrorMsg").text('OutSource Lab Name Already Exist');
                            modelAlert('OutSource Lab Name Already Exist');
                            $('#txtName').focus();                            
                        }
                        else {
                            modelAlert('Error occurred, Please contact administrator');
                           // $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                        }
                        $("#btnSave").removeAttr('disabled');
                    },
                    error: function (xhr, status) {
                        modelAlert('Error occurred, Please contact administrator');
                      //  $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    }
                });
            }
            else {
                $('#btnSave').removeAttr('disabled');
            }
        }

        function validateOutsource() {
            if ($.trim($('#txtName').val()) == "") {
                modelAlert('Please Enter Lab Name');
               //  $("#spnErrorMsg").text('Please Enter Lab Name');
                $('#txtName').focus();
                return false;
            }
            if ($.trim($('#txtContactPerson').val()) == "") {
                modelAlert('Please Enter Contact Person Name');
                return false;
            }
            if ($.trim($('#<%=txtContactNo.ClientID%>').val()) == "") {
                modelAlert('Please Enter Contact Number');
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
